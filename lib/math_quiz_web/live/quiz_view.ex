defmodule MathQuizWeb.QuizView do
  alias MathQuizWeb.FormModels
  alias Phoenix.LiveView.AsyncResult
  alias MathQuizWeb.FormModels.QuizGenerateForm
  import Ecto.Changeset
  use MathQuizWeb, :live_view

  def mount(params, _session, socket) do
    quiz_id = params["quiz_id"]
    quiz = MathQuiz.Quiz.fetch_quiz(quiz_id)

    {:ok,
     socket
     |> assign(quiz_id: quiz_id)
     |> assign(quiz: quiz)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>Math Quiz {@quiz_id}</div>
    </div>
    """
  end
end
