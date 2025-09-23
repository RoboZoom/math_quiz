defmodule MathQuiz.QuizCache do
  use GenServer

  alias MathQuiz.Models

  @impl true
  def init(_init_arg) do
    {:ok,
     %Models.QuizCache{
       next_id: 1,
       quizzes: []
     }}
  end
end
