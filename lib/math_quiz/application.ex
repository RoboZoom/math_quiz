defmodule MathQuiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MathQuizWeb.Telemetry,
      # MathQuiz.Repo,
      {DNSCluster, query: Application.get_env(:math_quiz, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MathQuiz.PubSub},
      MathQuiz.QuizCache,
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

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MathQuizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
