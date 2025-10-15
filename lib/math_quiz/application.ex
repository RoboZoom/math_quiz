defmodule MathQuiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Nx.global_default_backend({EXLA.Backend, client: :host})

    children = [
      MathQuizWeb.Telemetry,
      # MathQuiz.Repo,
      {DNSCluster, query: Application.get_env(:math_quiz, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MathQuiz.PubSub},
      # {Nx.Serving, serving: setup_llm(), name: MyLLM},
      {MathQuiz.QuizCache, name: MathQuiz.QuizCache},
      # Start a worker by calling: MathQuiz.Worker.start_link(arg)
      # {MathQuiz.Worker, arg},
      # Start to serve requests, typically the last entry
      MathQuizWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MathQuiz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def setup_llm() do
    # token = File.read!("token.txt")
    repo = {:hf, "HuggingFaceTB/SmolLM3-3B"}

    {:ok, model_info} =
      Bumblebee.load_model(repo,
        backend: EXLA.Backend,
        module: Bumblebee.Text.Llama,
        architecture: :for_causal_language_modeling
      )

    IO.puts("Model Loaded.")

    {:ok, tokenizer} = Bumblebee.load_tokenizer(repo)

    IO.puts("Tokenizer Loaded.")

    {:ok, generation_config} = Bumblebee.load_generation_config(repo)

    generation_config =
      Bumblebee.configure(generation_config,
        max_new_tokens: 256,
        strategy: %{type: :multinomial_sampling, top_p: 0.6}
      )

    Bumblebee.Text.generation(model_info, tokenizer, generation_config,
      compile: [batch_size: 10, sequence_length: 512],
      # stream: true,
      defn_options: [compiler: EXLA]
    )
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MathQuizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
