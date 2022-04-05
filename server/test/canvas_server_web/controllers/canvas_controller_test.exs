defmodule CanvasServerWeb.CanvasControllerTest do
  use CanvasServerWeb.ConnCase
  alias CanvasServer.Drawing

  test "POST /canvases", %{conn: conn} do
    conn = post(conn, "/canvases")
    response = json_response(conn, 200)
    assert is_binary(response["id"])
  end

  test "GET /canvases/:id", %{conn: conn} do
    %{id: canvas_id} = Drawing.create_canvas!()

    conn = get(conn, "/canvases/#{canvas_id}")
    response = json_response(conn, 200)
    assert %{"id" => ^canvas_id} = response
  end
end
