defmodule CanvasServerWeb.CanvasControllerTest do
  use CanvasServerWeb.ConnCase

  test "POST /canvases", %{conn: conn} do
    conn = post(conn, "/canvases")
    response = json_response(conn, 200)
    assert is_binary(response["id"])
  end

  test "GET /canvases/:id", %{conn: conn} do
    conn = get(conn, "/canvases/d41fcb72-291b-4033-8639-c59a06c2c0cb")
    response = json_response(conn, 200)
    assert %{"id" => "d41fcb72-291b-4033-8639-c59a06c2c0cb"} = response
  end
end
