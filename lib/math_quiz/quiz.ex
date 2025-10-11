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

    question_prompt =
      "Write a narrative story question for children for the math problem #{question.first_num} plus #{question.second_num}.  Please provide the response in json format, with the text having the key 'storyText'."
      |> IO.inspect(label: "Prompt")

    Nx.Serving.batched_run(MyLLM, question_prompt) |> IO.inspect(label: "NX Output")

    # Nx.Serving.run(serving, question_prompt) |> IO.inspect(label: "NX Output")
  end
end
