defmodule CanvasServerWeb.CanvasView do
  use CanvasServerWeb, :view

  def render("show.json", %{canvas: canvas}) do
    %{
      id: canvas.id
    }
  end
end
