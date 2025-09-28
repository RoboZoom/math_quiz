defmodule MathQuiz.Models.MathQuizOp do
  @moduledoc """
  Schema for MathOperator used inside of quiz.
  """
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :operator, Ecto.Enum, values: [:add, :multiply, :subtract, :divide]
    field :max_param, :integer
  end

  def changeset(obj, attr) do
    obj
    |> cast(attr, [:operator, :max_param])
    |> validate_required([:operator, :max_param])
    |> validate_number(:max_param, greater_than: 0)
  end
end
