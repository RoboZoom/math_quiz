defmodule MathQuiz.QuizCache do
  @moduledoc """
  GenServer implementation to cache quiz results.

  Not suitable at scale.  Vulnerable to token conflicts for quiz_id
  """
  use GenServer

  alias MathQuiz.Models
  alias MathQuiz.QuestionGenerator

  @impl true
  def init(_init_arg) do
    {:ok,
     %Models.QuizCache{
       next_id: 1,
       quizzes: []
     }}
  end

  @doc """
  Returns {:ok, Quiz} or {:error, _error}
  """
  @impl true
  def handle_call({:get_quiz, quiz_id}, _from, %Models.QuizCache{} = state) do
    quiz = Enum.find(state.quizzes, &(&1.id == quiz_id))

    case quiz do
      nil -> {:reply, {:error, "Quiz not found"}, state}
      _ -> {:reply, {:ok, quiz}, state}
    end
  end

  @impl true
  def handle_call(
        {:generate_quiz, %Models.MathQuizParams{} = params},
        _from,
        %Models.QuizCache{} = state
      ) do
    # Note: The below logic is subject to conflicting quiz generations when deployed at scale.
    quiz_id = state.next_id
    new_id = quiz_id + 1

    quiz = %Models.MathQuiz{
      id: quiz_id,
      params: params,
      questions: QuestionGenerator.generate_quiz_items(params)
    }

    new_state = %{state | next_id: new_id, quizzes: [quiz | state.quizzes]}

    {:reply, {:ok, quiz_id}, new_state}
  end
end
