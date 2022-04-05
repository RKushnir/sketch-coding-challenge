defmodule CanvasServerWeb.RectangleControllerTest do
  use CanvasServerWeb.ConnCase
  alias CanvasServer.Drawing
  alias CanvasServer.Repo

  test "POST /rectangles", %{conn: conn} do
    %{id: canvas_id} = canvas = Drawing.create_canvas!()

    conn =
      post(conn, "/canvases/#{canvas_id}/rectangles", %{
        offset_top: "1",
        offset_left: "2",
        height: "3",
        width: "4",
        fill_character: "*",
        outline_character: "%"
      })

    assert json_response(conn, 200)

    canvas = Repo.preload(canvas, :rectangles)
    assert length(canvas.rectangles) == 1

    rectangle = hd(canvas.rectangles)
    assert rectangle.offset_top == 1
    assert rectangle.offset_left == 2
    assert rectangle.height == 3
    assert rectangle.width == 4
    assert rectangle.fill_character == "*"
    assert rectangle.outline_character == "%"
  end

  test "POST /rectangles returns error if canvas is not found", %{conn: conn} do
    assert_error_sent 404, fn ->
      post(conn, "/canvases/d41fcb72-291b-4033-8639-c59a06c2c0cb/rectangles", %{
        offset_top: "1",
        offset_left: "2",
        height: "3",
        width: "4",
        fill_character: "*"
      })
    end
  end

  test "POST /rectangles returns errors if rectangle attributes are invalid", %{conn: conn} do
    %{id: canvas_id} = canvas = Drawing.create_canvas!()

    conn =
      post(conn, "/canvases/#{canvas_id}/rectangles", %{
        offset_top: "1",
        offset_left: "-2",
        height: "3",
        width: "4"
      })

    response = json_response(conn, 422)

    canvas = Repo.preload(canvas, :rectangles)
    assert length(canvas.rectangles) == 0

    assert %{
             "errors" => %{
               "fill_character" => ["Either fill_character or outline_character must be present"],
               "offset_left" => ["must be greater than or equal to 0"]
             }
           } = response
  end
end
