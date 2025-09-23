defmodule MathQuizWeb.PageController do
  use MathQuizWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
