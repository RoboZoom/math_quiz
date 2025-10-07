defmodule MathQuizWeb.QuizView do
  alias MathQuiz.Quiz
  use MathQuizWeb, :live_view
  import MathQuizWeb.MathComponents

  def mount(params, _session, socket) do
    quiz_id = params["quiz_id"]

    quiz =
      case MathQuiz.Quiz.fetch_quiz(quiz_id) do
        {:ok, quiz} -> quiz |> Quiz.shuffle_quiz()
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
        <div class="flex flex-wrap gap-16 py-6 px-12">
          <%= for question <- @quiz.questions do %>
            <.math_problem problem={question} />
          <% end %>
        </div>
      <% else %>
        <div>Error loading quiz.</div>
      <% end %>
    </div>
    """
  end
end
