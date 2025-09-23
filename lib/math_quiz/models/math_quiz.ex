defmodule MathQuiz.Models.MathQuiz do
  @moduledoc """
  Provides data model for math quiz.
  """
  alias MathQuiz.Models
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    embeds_one :params, Models.MathQuizParams
    embeds_many :questions, Models.MathQuizItem
  end

  def changeset(obj, attrs) do
    obj
    |> cast(attrs, [:id])
    |> cast_embed(:params, required: true)
    |> cast_embed(:questions, required: true)
  end
end
