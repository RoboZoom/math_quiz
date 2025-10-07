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
    model_name = "openai-community/gpt2"
    {:ok, granite} = Bumblebee.load_model({:hf, model_name})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, model_name})

    {:ok, generation_config} = Bumblebee.load_generation_config({:hf, model_name})

    serving = Bumblebee.Text.generation(granite, tokenizer, generation_config)

    question_prompt =
      "Write a narrative story question for children for the math problem #{question.first_num} plus #{question.second_num}."
      |> IO.inspect(label: "Prompt")

    # text_input = Kino.Input.text(question_prompt, default: "Tomorrow it will be")
    # text = Kino.Input.read(text_input)

    Nx.Serving.run(serving, question_prompt)
  end
end
