defmodule MathQuiz.Quiz do
  @moduledoc """
  Provides external interface to interact with MathQuizCache GenServer (or whatever state solution exsists)
  """
  alias MathQuiz.Models

  def generate_quiz(%Models.MathQuizParams{} = quiz_params) do
    GenServer.call(MathQuiz.QuizCache, {:generate_quiz, quiz_params})
  end

  def fetch_quiz(quiz_id) do
    GenServer.call(MathQuiz.QuizCache, {:get_quiz, quiz_id})
  end

  def shuffle_quiz(%MathQuiz.Models.MathQuiz{} = q) do
    Map.update!(q, :questions, &Enum.shuffle(&1))
  end
end
