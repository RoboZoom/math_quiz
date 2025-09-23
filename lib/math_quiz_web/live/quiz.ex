defmodule MathQuizWeb.Quiz do
  alias MathQuizWeb.FormModels.QuizGenerateForm
  use MathQuizWeb, :live_view

  def mount(_params, _session, socket) do
    form =
      %QuizGenerateForm{}
      |> QuizGenerateForm.changeset(%{})
      |> to_form()

    {:ok, socket |> assign(form: form)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen">
      <div class="hero bg-base-200 min-h-1/2">
        <div class="hero-content text-center">
          <div class="max-w-md">
            <h1 class="text-5xl font-bold">Math Quiz Generator!</h1>
            <p class="py-6">
              Generates math quiz for online execution or print.
            </p>
          </div>
        </div>
      </div>
      <div class="flex h-full bg-base-100 justify-center p-10">
        <div class="p-8 border rounded-md border-base-300">
          <div class="text-2xl font-bold my-4">Quiz Generation Form</div>
          <div>
            <form for{@form} phx-change="validate" phx-submit="phx-submit">
              <.input field={@form[:num_questions]} label="Number of Questions" />
              <.input field={@form[:max_sum]} label="Max Sum" />
              <fieldset class="fieldset bg-base-100 border-base-300 rounded-box w-64 border p-4">
                <legend class="fieldset-legend">Mathematical Operations</legend>
                <label class="label">
                  <input type="checkbox" checked="checked" class="checkbox" /> Addition
                </label>
                <label class="label">
                  <input type="checkbox" checked="checked" class="checkbox" /> Subtraction
                </label>
                <label class="label">
                  <input type="checkbox" checked="checked" class="checkbox" /> Multiplication
                </label>
              </fieldset>
              <div class="py-4">
                <.button>Generate</.button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"quiz_generate_form" => vals}, socket) do
    f =
      %QuizGenerateForm{}
      |> QuizGenerateForm.changeset(vals)
      |> to_form(action: :validate)

    {:noreply, assign(socket, form: f)}
  end
end
