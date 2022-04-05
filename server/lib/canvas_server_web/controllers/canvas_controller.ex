defmodule CanvasServerWeb.CanvasController do
  use CanvasServerWeb, :controller

  def create(conn, _params) do
    canvas = %{id: "84a4a86c-67c2-4d3a-9c6c-b36df596b232"}

    render(conn, "show.json", canvas: canvas)
  end

  def show(conn, params) do
    canvas = %{id: params["id"]}

    render(conn, "show.json", canvas: canvas)
  end
end
