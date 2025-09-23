defmodule MathQuiz.Repo do
  use Ecto.Repo,
    otp_app: :math_quiz,
    adapter: Ecto.Adapters.Postgres
end
