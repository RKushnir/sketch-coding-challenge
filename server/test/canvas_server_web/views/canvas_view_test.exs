defmodule CanvasServerWeb.CanvasViewTest do
  use CanvasServerWeb.ConnCase, async: true
  alias CanvasServerWeb.CanvasView
  alias CanvasServer.Drawing

  test "renders create.json" do
    %{id: canvas_id} = canvas = Drawing.create_canvas!()

    assert %{
             id: ^canvas_id
           } = CanvasView.render("create.json", canvas: canvas)
  end

  test "renders show.json" do
    canvas = Drawing.create_canvas!()

    {:ok, _} =
      Drawing.draw_rectangle(canvas, %{
        offset_top: 1,
        offset_left: 2,
        height: 3,
        width: 4,
        fill_character: "#"
      })

    canvas = Drawing.preload_rectangles(canvas)

    assert %{
             id: _,
             rectangles: [
               %{
                 fill_character: "#",
                 height: 3,
                 offset_left: 2,
                 offset_top: 1,
                 outline_character: nil,
                 width: 4
               }
             ]
           } = CanvasView.render("show.json", canvas: canvas)
  end
end
