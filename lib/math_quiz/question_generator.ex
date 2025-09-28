defmodule MathQuiz.QuestionGenerator do
  @moduledoc """
  Contains question generation logic.

  `gen_math_question(operatior, param)` is the core logic which takes parameters specific to each math problem type and outputs a math question.
  """
  alias MathQuiz.Models.MathQuizItem
  alias MathQuiz.Models

  def generate_quiz_items(%Models.MathQuizParams{} = params) do
    l = length(params.operator_params)

    params.operator_params
    |> Enum.with_index()
    |> Enum.reduce([], fn {el, index}, ac ->
      upper_bound = get_num_op_questions(params.num_questions, l, index)

      1..upper_bound
      |> Enum.to_list()
      |> Enum.map(fn _x -> gen_math_question(el.operator, el.max_param) end)
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

  def gen_math_question(:add, max_param) do
    a = Enum.random(1..(max_param - 1))
    b = Enum.random(1..(max_param - 1))

    case a + b do
      s when s <= max_param ->
        %MathQuizItem{
          first_num: a,
          second_num: b,
          operator: :add,
          result: a + b
        }

      _ ->
        gen_math_question(:add, max_param)
    end
  end

  def gen_math_question(:subtract, max_param) do
    a = Enum.random(1..max_param)
    b = Enum.random(0..a)

    %MathQuizItem{
      first_num: a,
      second_num: b,
      operator: :subtract,
      result: a - b
    }
  end
end
