defmodule CanvasServer.DrawingTest do
  use CanvasServer.DataCase

  alias CanvasServer.Drawing

  describe "canvases" do
    alias CanvasServer.Drawing.Canvas

    test "create_canvas!/0 creates a canvas" do
      assert %Canvas{} = canvas = Drawing.create_canvas!()
      assert is_binary(canvas.id)
      assert Drawing.get_canvas!(canvas.id) == canvas
    end
  end
end
