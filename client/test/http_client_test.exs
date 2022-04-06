defmodule CanvasClient.HTTPClientTest do
  use ExUnit.Case, async: true
  alias CanvasClient.{Canvas, HTTPClient, Rectangle}
  import Tesla.Mock

  describe "create_canvas/0" do
    test "sends a create canvas request and returns the new canvas" do
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

  describe "draw_rectangle/1" do
    test "sends a draw rectangle request and returns :ok" do
      mock(fn
        %{
          method: :post,
          body: body,
          url: "http://localhost:4000/canvases/8c375cd2-eeaa-42b7-9295-c790129a6598/rectangles"
        } ->
          assert Jason.decode!(body) == %{
                   "offset_top" => 3,
                   "offset_left" => 4,
                   "width" => 5,
                   "height" => 6,
                   "fill_character" => "@",
                   "outline_character" => "#"
                 }

          json(%{})
      end)

      assert :ok ==
               HTTPClient.draw_rectangle(%{
                 canvas_id: "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 offset_top: 3,
                 offset_left: 4,
                 width: 5,
                 height: 6,
                 fill_character: "@",
                 outline_character: "#"
               })
    end

    test "returns error tuple with :canvas_not_found if the canvas id is not valid" do
      mock(fn
        %{
          method: :post,
          url: "http://localhost:4000/canvases/8c375cd2-eeaa-42b7-9295-c790129a6598/rectangles"
        } ->
          json(%{}, status: 404)
      end)

      assert {:error, :canvas_not_found} =
               HTTPClient.draw_rectangle(%{
                 canvas_id: "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 offset_top: 3
               })
    end

    test "returns error tuple with validation errors if the rectangle attributes were rejected" do
      mock(fn
        %{
          method: :post,
          url: "http://localhost:4000/canvases/8c375cd2-eeaa-42b7-9295-c790129a6598/rectangles"
        } ->
          json(%{"errors" => %{"offset_left" => ["can't be blank"]}}, status: 422)
      end)

      assert {:error, validation_errors} =
               HTTPClient.draw_rectangle(%{
                 canvas_id: "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 offset_top: 3
               })

      assert validation_errors == %{"offset_left" => ["can't be blank"]}
    end

    test "returns error tuple with :unknown_error if unexpected error happens" do
      mock(fn
        %{
          method: :post,
          url: "http://localhost:4000/canvases/8c375cd2-eeaa-42b7-9295-c790129a6598/rectangles"
        } ->
          json(%{}, status: 500)
      end)

      assert {:error, :unknown_error} =
               HTTPClient.draw_rectangle(%{
                 canvas_id: "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 offset_top: 3
               })
    end
  end

  describe "fetch_canvas/1" do
    test "returns a canvas given its id" do
      mock(fn
        %{
          method: :get,
          url: "http://localhost:4000/canvases/8c375cd2-eeaa-42b7-9295-c790129a6598"
        } ->
          json(%{
            "id" => "8c375cd2-eeaa-42b7-9295-c790129a6598",
            "rectangles" => [
              %{
                offset_top: 1,
                offset_left: 3,
                height: 5,
                width: 7,
                fill_character: "%",
                outline_character: "@"
              },
              %{
                offset_top: 2,
                offset_left: 4,
                height: 6,
                width: 8,
                fill_character: "?"
              }
            ]
          })
      end)

      assert {:ok, %Canvas{} = canvas} =
               HTTPClient.fetch_canvas("8c375cd2-eeaa-42b7-9295-c790129a6598")

      assert canvas.id == "8c375cd2-eeaa-42b7-9295-c790129a6598"

      assert canvas.rectangles == [
               %Rectangle{
                 offset_top: 1,
                 offset_left: 3,
                 height: 5,
                 width: 7,
                 fill_character: "%",
                 outline_character: "@"
               },
               %Rectangle{
                 offset_top: 2,
                 offset_left: 4,
                 height: 6,
                 width: 8,
                 fill_character: "?"
               }
             ]
    end

    test "returns error tuple with :canvas_not_found if the canvas id is not valid" do
      mock(fn
        %{
          method: :get,
          url: "http://localhost:4000/canvases/8c375cd2-eeaa-42b7-9295-c790129a6598"
        } ->
          json(%{}, status: 404)
      end)

      assert {:error, :canvas_not_found} =
               HTTPClient.fetch_canvas("8c375cd2-eeaa-42b7-9295-c790129a6598")
    end
  end
end
