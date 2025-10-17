defmodule MathQuiz.Models.MathQuizItem do
  use Ecto.Schema
  # import Ecto.Changeset

  @moduledoc """
  Struct to represent quiz item.

  Operator can be the following fields:
  [:subtract, :add, :multiply]

  In equation 10 - 8 = 2, you would have the following struct:
  > %MathQuizItem{
  id: 1
  first_num: 10,
  second_num: 8,
  operator: :subtract,
  result: 2
  }

  """

  # @enforce_keys [:id, :first_num, :second_num, :operator, :result]
  # defstruct [:id, :first_num, :second_num, :operator, :result]

  embedded_schema do
    field :first_num, :integer
    field :second_num, :integer
    field :operator, Ecto.Enum, values: [:add, :multiply, :subtract, :divide]
    field :result, :integer
  end
end
