defmodule CanvasServerWeb.CanvasController do
  use CanvasServerWeb, :controller
  alias CanvasServer.Drawing

  def create(conn, _params) do
    canvas = Drawing.create_canvas!()

    render(conn, "show.json", canvas: canvas)
  end

  def show(conn, params) do
    canvas = Drawing.get_canvas!(params["id"])

    render(conn, "show.json", canvas: canvas)
  end
end
