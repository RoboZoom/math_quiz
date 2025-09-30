defmodule MathQuizWeb.QuizView do
  alias MathQuiz.Models

  use MathQuizWeb, :live_view

  def mount(params, _session, socket) do
    quiz_id = params["quiz_id"]

    quiz =
      case MathQuiz.Quiz.fetch_quiz(quiz_id) do
        {:ok, quiz} -> quiz
        {:error, _msg} -> :error
        _ -> :error
      end

    {:ok,
     socket
     |> assign(quiz_id: quiz_id)
     |> assign(quiz: quiz)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="text-3xl">Math Quiz {@quiz_id}</div>

      <%= if @quiz != :error do %>
        <div class="flex py-6 px-4">
          <%= for question <- @quiz.questions do %>
            <div>Math question here.</div>
          <% end %>
        </div>
      <% else %>
        <div>Error loading quiz.</div>
      <% end %>
    </div>
    """
  end
end
