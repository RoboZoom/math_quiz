defmodule MathQuiz.Models.MathQuizParams do
  @moduledoc """
  Model for Math Quiz.

  field num_questions: Number of questions in quiz
  field operator_params: The types (and details of) operators to use in creating math questions
  """

  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :num_questions, :integer

    embeds_many :operator_params, MathQuiz.Models.MathQuizOp
  end

  def changeset(obj, attrs) do
    obj
    |> cast(attrs, [:num_questions])
    |> cast_embed(:operator_params)
    |> validate_number(:num_questions, greater_than: 0, less_than: 275)
  end
end
