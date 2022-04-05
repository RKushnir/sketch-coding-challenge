defmodule CanvasClient.HTTPClientTest do
  use ExUnit.Case
  alias CanvasClient.HTTPClient
  alias CanvasClient.Canvas

  describe "create_canvas/0" do
    test "returns a new canvas" do
      assert {:ok, %Canvas{} = canvas} = HTTPClient.create_canvas()
      assert is_binary(canvas.id)
    end
  end
end
