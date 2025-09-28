defmodule MathQuiz.Quiz do
  @moduledoc """
  Provides external interface to interact with MathQuizCache GenServer (or whatever state solution exsists)
  """
  alias MathQuiz.Models

  def generate_quiz(%Models.MathQuizParams{} = quiz_params) do
    GenServer.call(MathQuiz.QuizCache, {:generate_quiz, quiz_params})
  end
end
