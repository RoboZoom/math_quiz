defmodule MathQuiz.QuizCache do
  use GenServer

  alias MathQuiz.Models

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
  def handle_cast({:generate_quiz, params}, _from, %Models.QuizCache{} = state) do
    # To Implement
  end
end
