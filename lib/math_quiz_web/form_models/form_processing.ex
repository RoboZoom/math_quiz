defmodule MathQuizWeb.FormModels.FormProcessing do
  alias MathQuizWeb.FormModels
  alias MathQuiz.Models

  def process_quiz_params_form(%FormModels.QuizGenerateForm{} = params) do
    op_params = [
      %Models.MathQuizOp{
        operator: :add
      }
    ]
    m = %Models.MathQuizParams{
      num_questions: params.num_questions
    }
  end
end
