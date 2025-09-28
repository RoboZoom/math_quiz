defmodule MathQuizWeb.FormModels.QuizGenerateForm do
  @moduledoc """
  Schema for quiz generation form.
  """
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :num_questions, :integer
    field :max_sum, :integer
    field :add, :boolean, default: false
    field :subtraction, :boolean, default: false
    field :max_minuend, :integer
  end

  def changeset(obj, attrs) do
    obj
    |> cast(attrs, [:num_questions, :max_sum, :add, :subtraction, :max_minuend])
    |> validate_required([:num_questions, :max_sum], message: "This field is required.")
    |> validate_number(:max_sum,
      less_than_or_equal_to: 1000,
      greater_than: 0,
      message: "Max Sum must be greater than 0 and less than 1000"
    )
    |> validate_number(:num_questions,
      less_than_or_equal_to: 250,
      greater_than: 0,
      message: "Number of Questions must be greater than 0 and less than or equal to 250"
    )
    |> validate_number(:max_minuend,
      less_than_or_equal_to: 1000,
      greater_than: 0,
      message: "Max Minuend must be greater than 0 and less than 1000"
    )
  end
end
