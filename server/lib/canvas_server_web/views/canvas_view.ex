defmodule CanvasServerWeb.CanvasView do
  use CanvasServerWeb, :view

  def render("create.json", %{canvas: canvas}) do
    %{id: canvas.id}
  end

  def render("show.json", %{canvas: canvas}) do
    %{
      id: canvas.id,
      rectangles: Enum.map(canvas.rectangles, &render_rectangle/1)
    }
  end

  defp render_rectangle(rectangle) do
    %{
      offset_top: rectangle.offset_top,
      offset_left: rectangle.offset_left,
      height: rectangle.height,
      width: rectangle.width,
      fill_character: rectangle.fill_character,
      outline_character: rectangle.outline_character
    }
  end
end
