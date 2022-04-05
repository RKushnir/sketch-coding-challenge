defmodule CanvasServerWeb.RectangleController do
  use CanvasServerWeb, :controller
  alias CanvasServer.Drawing
  alias CanvasServer.Drawing.Rectangle

  def create(conn, params) do
    canvas = Drawing.get_canvas!(params["canvas_id"])

    with {:ok, %Rectangle{}} <- Drawing.draw_rectangle(canvas, params) do
      json(conn, %{})
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(CanvasServerWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end
end
