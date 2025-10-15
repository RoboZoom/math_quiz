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

  def make_story_question(%MathQuiz.Models.MathQuizItem{} = question) do
    IO.puts("Making story question.")

    # message =
    #   "Write a narrative story question for children for the math problem #{question.first_num} plus #{question.second_num}."
    #   |> make_story_message()
    #   |> IO.inspect(label: "Message")

    message = hard_prompt() |> IO.inspect(label: "Message")

    Nx.Serving.batched_run(MyLLM, message) |> IO.inspect(label: "NX Output")
  end

  defp make_story_message(prompt) do
    [
      teacher_role(),
      %{
        role: "user",
        content: prompt
      }
    ]
    |> JSON.encode!()
  end

  defp teacher_role(),
    do: %{
      role: "system",
      content: "You are a children's math teacher.  Use words suitable for a child aged 6 - 10."
    }

  def hard_prompt() do
    """
    [
    {
    role: "system",
    content: "You are a children's math teacher.  Use words suitable for a child aged 6 - 10.  Your answers are in plain english text, not code."

    },
    {
    role: "user"
    content: "Write a narrative story word problem for the math problem 3 + 9.  The response should be no longer than 250 characters."
    }
    ]
    """
  end
end
