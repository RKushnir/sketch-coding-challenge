defmodule CanvasClient.HTTPClient do
  alias CanvasClient.Canvas

  def create_canvas do
    canvas = %Canvas{id: "636d3763-48ee-49d1-8dcb-9e1931e930b7"}
    {:ok, canvas}
  end
end
