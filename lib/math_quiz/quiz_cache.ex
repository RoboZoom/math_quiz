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
      questions: generate_quiz_items(params)
    }

    new_state = %{state | next_id: new_id, quizzes: [quiz | state.quizzes]}

    {:reply, quiz_id, new_state}
  end

  def generate_quiz_items(%Models.MathQuizParams{} = params) do
    l = length(params.operator_params)

    params.operator_params
    |> Enum.with_index()
    |> Enum.reduce([], fn {el, index}, ac ->
      upper_bound = get_num_op_questions(params.num_questions, l, index)

      1..upper_bound
      |> Enum.to_list()
      |> Enum.map(fn _x -> QuestionGenerator.gen_math_question(el.operator, el.max_param) end)
      |> Enum.concat(ac)
    end)
  end

  defp get_num_op_questions(total_questions, num_params, index) do
    base_questions = Integer.floor_div(total_questions, num_params)
    mod = Integer.mod(total_questions, num_params)

    case mod - index do
      x when x > 0 -> base_questions + 1
      _ -> base_questions
    end
  end
end
