defmodule CanvasClient.HTTPClientTest do
  use ExUnit.Case
  alias CanvasClient.{Canvas, HTTPClient}
  import Tesla.Mock

  describe "create_canvas/0" do
    test "returns a new canvas" do
      mock(fn
        %{method: :post, url: "http://localhost:4000/canvases"} ->
          json(%{id: "8c375cd2-eeaa-42b7-9295-c790129a6598"})
      end)

      assert {:ok, %Canvas{} = canvas} = HTTPClient.create_canvas()
      assert canvas.id == "8c375cd2-eeaa-42b7-9295-c790129a6598"
    end

    test "returns error if canvas creation failed" do
      mock(fn
        %{method: :post, url: "http://localhost:4000/canvases"} ->
          json(%{something: "wrong"})
      end)

      assert :error = HTTPClient.create_canvas()
    end
  end
end
