defmodule MathQuizWeb.QuizCreate do
  @moduledoc """
  Live View which Renders Quiz Generation Form.
  """
  alias MathQuizWeb.FormModels.FormProcessing
  alias Phoenix.LiveView.AsyncResult
  alias MathQuizWeb.FormModels.QuizGenerateForm
  import Ecto.Changeset
  use MathQuizWeb, :live_view

  def mount(_params, _session, socket) do
    form =
      %QuizGenerateForm{}
      |> QuizGenerateForm.changeset(%{})
      |> to_form()

    {:ok,
     socket
     |> assign(form: form)
     |> assign(:quiz_id, AsyncResult.ok(-1))}
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
      <%= if @quiz_id.loading == true do %>
        <div>
          Generating Quiz <span class="loading loading-dots loading-xl"></span>
        </div>
      <% else %>
        <div class="flex h-full bg-base-100 justify-center p-10">
          <div class="p-8 border rounded-md border-base-300">
            <div class="text-2xl font-bold my-4">Quiz Generation Form</div>
            <div>
              <form for{@form} phx-change="validate" phx-submit="phx-submit">
                <.input field={@form[:num_questions]} label="Number of Questions" />

                <fieldset class="fieldset bg-base-100 border-base-300 rounded-box w-64 border p-4">
                  <legend class="fieldset-legend">Mathematical Operations</legend>
                  <label class="label">
                    <.input
                      type="checkbox"
                      field={@form[:add]}
                      checked="true"
                      class="checkbox"
                    /> Addition
                  </label>
                  <label class="label">
                    <.input type="checkbox" field={@form[:subtraction]} class="checkbox" />
                    Subtraction
                  </label>
                </fieldset>

                <.input field={@form[:max_sum]} label="Max Sum" />
                <.input field={@form[:max_minuend]} label="Max Minuend" />

                <div class="py-4">
                  <.button>Generate</.button>
                </div>
              </form>
            </div>
          </div>
        </div>
      <% end %>
      <div></div>
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

  def handle_event("phx-submit", %{"quiz_generate_form" => vals}, socket) do
    ch =
      %QuizGenerateForm{}
      |> QuizGenerateForm.changeset(vals)

    case ch.valid? do
      true ->
        form_vals = apply_changes(ch)
        IO.puts("Creating Quiz!")

        {:noreply,
         socket
         |> assign(:quiz_id, AsyncResult.loading())
         |> start_async(:generate_quiz, fn ->
           FormProcessing.submit_quiz(form_vals)
         end)}

      false ->
        IO.inspect(socket.assigns.form[:add])
        {:noreply, socket |> assign(form: to_form(ch, action: :validate))}
    end
  end

  def handle_async(:generate_quiz, {:ok, quiz_response}, socket) do
    {:ok, quiz_id} = quiz_response
    {:noreply, push_navigate(socket, to: ~p"/quiz_view/#{quiz_id}")}
  end
end
