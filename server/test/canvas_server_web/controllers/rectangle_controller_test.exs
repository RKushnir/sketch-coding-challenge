defmodule CanvasServerWeb.RectangleControllerTest do
  use CanvasServerWeb.ConnCase

  test "POST /rectangles", %{conn: conn} do
    conn = post(conn, "/canvases/d41fcb72-291b-4033-8639-c59a06c2c0cb/rectangles")
    assert json_response(conn, 200)
  end
end
