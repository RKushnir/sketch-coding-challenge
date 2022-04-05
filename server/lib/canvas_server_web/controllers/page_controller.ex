defmodule CanvasServerWeb.PageController do
  use CanvasServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
