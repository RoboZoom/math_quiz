defmodule MathQuizWeb.FormModels.FormProcessing do
  alias MathQuizWeb.FormModels
  alias MathQuiz.Models

  def submit_quiz(%FormModels.QuizGenerateForm{} = form_params) do
    process_quiz_params_form(form_params)
    |> MathQuiz.Quiz.generate_quiz()
  end

  def process_quiz_params_form(%FormModels.QuizGenerateForm{} = params) do
    m = %Models.MathQuizParams{
      num_questions: params.num_questions,
      operator_params: []
    }

    m
    |> process_quiz_params(:add, params)
    |> process_quiz_params(:subtract, params)
  end

  def process_quiz_params(
        %Models.MathQuizParams{} = quiz_params,
        :add,
        %FormModels.QuizGenerateForm{} = form_params
      ) do
    case form_params.add do
      true ->
        op_data = %Models.MathQuizOp{
          operator: :add,
          max_param: form_params.max_sum
        }

        %{quiz_params | operator_params: [op_data | quiz_params.operator_params]}

      false ->
        quiz_params
    end
  end

  def process_quiz_params(
        %Models.MathQuizParams{} = quiz_params,
        :subtract,
        %FormModels.QuizGenerateForm{} = form_params
      ) do
    case form_params.subtraction do
      true ->
        op_data = %Models.MathQuizOp{
          operator: :subtract,
          max_param: form_params.max_minuend
        }

        %{quiz_params | operator_params: [op_data | quiz_params.operator_params]}

      false ->
        quiz_params
    end
  end
end
