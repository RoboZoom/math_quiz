defmodule MathQuizWeb.Narrative do
  alias MathQuiz.Quiz
  alias MathQuiz.Models
  use MathQuizWeb, :live_view
  import MathQuizWeb.MathComponents

  def mount(_params, _session, socket) do
    # quiz_id = params["quiz_id"]
    IO.puts("Mounting Narrative Component")
    quiz_id = "1"

    quiz =
      case MathQuiz.Quiz.fetch_quiz(quiz_id) do
        {:ok, quiz} -> quiz |> Quiz.shuffle_quiz()
        {:error, _msg} -> :error
        _ -> :error
      end
      |> make_quiz_narrative()

    IO.puts("Narrative Component Created.")

    {:ok,
     socket
     |> assign(quiz_id: quiz_id)
     |> assign(quiz: quiz)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="text-3xl">Math Quiz {@quiz_id} (Narrative)!</div>

      <%= if @quiz != :error do %>
        <div class="flex flex-wrap gap-16 py-6 px-12">
          <%= for question <- @quiz.questions do %>
            <.story_math_problem problem={question} />
          <% end %>
        </div>
      <% else %>
        <div>Error loading quiz.</div>
      <% end %>
    </div>
    """
  end

  def make_quiz_narrative(%Models.MathQuiz{} = quiz) do
    Map.update!(quiz, :questions, &Enum.map(&1, fn x -> add_narrative_description(x) end))
    |> IO.inspect(label: "Story Maker")
  end

  def add_narrative_description(%Models.MathQuizItem{} = item) do
    response = Quiz.make_story_question(item)

    text =
      case response do
        %{result: result} -> result.text
        _ -> "N/A"
      end

    Map.put(item, :story_text, text) |> IO.inspect()
  end
end
