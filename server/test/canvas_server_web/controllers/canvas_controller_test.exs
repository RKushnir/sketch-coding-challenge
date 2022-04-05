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
    assert %{"id" => ^canvas_id, "rectangles" => []} = response
  end

  test "GET /canvases/:id returns rectangles in the order in which they were created", %{
    conn: conn
  } do
    %{id: canvas_id} = canvas = Drawing.create_canvas!()

    {:ok, _} =
      Drawing.draw_rectangle(canvas, %{
        offset_top: 1,
        offset_left: 2,
        height: 3,
        width: 4,
        fill_character: "#"
      })

    {:ok, _} =
      Drawing.draw_rectangle(canvas, %{
        offset_top: 10,
        offset_left: 20,
        height: 30,
        width: 40,
        fill_character: "%"
      })

    {:ok, _} =
      Drawing.draw_rectangle(canvas, %{
        offset_top: 100,
        offset_left: 200,
        height: 300,
        width: 400,
        fill_character: "&"
      })

    conn = get(conn, "/canvases/#{canvas_id}")
    response = json_response(conn, 200)

    assert %{
             "rectangles" => [
               %{
                 "fill_character" => "#",
                 "height" => 3,
                 "offset_left" => 2,
                 "offset_top" => 1,
                 "outline_character" => nil,
                 "width" => 4
               },
               %{
                 "fill_character" => "%",
                 "height" => 30,
                 "offset_left" => 20,
                 "offset_top" => 10,
                 "outline_character" => nil,
                 "width" => 40
               },
               %{
                 "fill_character" => "&",
                 "height" => 300,
                 "offset_left" => 200,
                 "offset_top" => 100,
                 "outline_character" => nil,
                 "width" => 400
               }
             ]
           } = response
  end
end
