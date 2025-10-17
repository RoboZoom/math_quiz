defmodule MathQuizWeb.MathComponents do
  use Phoenix.Component
  use Gettext, backend: MathQuizWeb.Gettext

  # alias Phoenix.LiveView.JS
  alias MathQuiz.Models

  attr :problem, :map
  attr :index, :integer, default: 0

  def math_problem(%{problem: %Models.MathQuizItem{operator: :add} = _problem} = assigns) do
    IO.inspect(assigns, label: "Assigns")

    ~H"""
    <div class="flex px-6 pb-12 pt-4 border border-base-500 rounded-md">
      <span class="text-xl">{@index}.</span>
      <div class="p-4 flex flex-col text-xl items-end">
        <div class="float-right">{@problem.first_num}</div>
        <div>
          <div class="float-right">{@problem.second_num}</div>
          <div class="float-left">+</div>
        </div>
        <div class="py-2 my-2 border-t-2 self-start height-48px w-full"></div>
      </div>
    </div>
    """
  end

  def math_problem(%{problem: %Models.MathQuizItem{operator: :subtract} = _problem} = assigns) do
    ~H"""
    <div class="flex px-6 pb-12 pt-4 border border-base-500 rounded-md">
      <span class="text-xl">{@index}.</span>
      <div class="p-4 flex flex-col text-xl items-end">
        <div class="float-right">{@problem.first_num}</div>
        <div>
          <div class="float-right">{@problem.second_num}</div>
          <div class="float-left">-</div>
        </div>
        <div class="py-2 my-2 border-t-2 self-start height-48px w-full"></div>
      </div>
    </div>
    """
  end

  def story_math_problem(%{problem: _problem} = assigns) do
    ~H"""
    <div class="p-4 flex flex-col text-xl items-end">
      <div>{@problem.story_text}</div>
    </div>
    """
  end
end
