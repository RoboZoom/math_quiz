defmodule MathQuizWeb.MathComponents do
  use Phoenix.Component
  use Gettext, backend: MathQuizWeb.Gettext

  # alias Phoenix.LiveView.JS
  alias MathQuiz.Models

  attr :problem, :map

  def math_problem(%{problem: %Models.MathQuizItem{operator: :add} = problem} = assigns) do
    ~H"""
    <div class="p-4 flex flex-col text-xl items-end">
      <div class="float-right">{@problem.first_num}</div>
      <div>
        <div class="float-right">{@problem.second_num}</div>
        <div class="float-left">+</div>
      </div>
      <div class="py-2 my-2 border-t-2 self-start height-48px w-full"></div>
    </div>
    """
  end

  def math_problem(%{problem: %Models.MathQuizItem{operator: :subtract} = _problem} = assigns) do
    ~H"""
    <div class="p-4 flex flex-col text-xl items-end">
      <div class="float-right">{@problem.first_num}</div>
      <div>
        <div class="float-right">{@problem.second_num}</div>
        <div class="float-left">-</div>
      </div>
      <div class="py-2 my-2 border-t-2 self-start height-48px w-full"></div>
    </div>
    """
  end
end
