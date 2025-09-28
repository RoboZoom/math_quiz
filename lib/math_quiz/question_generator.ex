defmodule MathQuiz.QuestionGenerator do
  @moduledoc """
  Contains question generation logic.

  `gen_math_question(operatior, param)` is the core logic which takes parameters specific to each math problem type and outputs a math question.
  """
  alias MathQuiz.Models.MathQuizItem

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
