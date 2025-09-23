defmodule MathQuiz.Models.QuizCache do
  alias MathQuiz.Models
  use Ecto.Schema

  embedded_schema do
    field :next_id, :integer

    embeds_many :quizzes, Models.MathQuiz
  end
end
