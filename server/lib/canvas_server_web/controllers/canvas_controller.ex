defmodule CanvasServerWeb.CanvasController do
  use CanvasServerWeb, :controller
  alias CanvasServer.Drawing

  def create(conn, _params) do
    canvas = Drawing.create_canvas!()

    render(conn, "create.json", canvas: canvas)
  end

  def show(conn, params) do
    canvas =
      params["id"]
      |> Drawing.get_canvas!()
      |> Drawing.preload_rectangles()

    render(conn, "show.json", canvas: canvas)
  end
end
