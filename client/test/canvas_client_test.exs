defmodule CanvasClient.CLITest do
  use ExUnit.Case

  alias CanvasClient.{Canvas, Rectangle}
  alias CanvasClient.CLI

  import ExUnit.CaptureIO
  import Mox

  setup :verify_on_exit!

  test "prints an error message for unsupported commands" do
    assert capture_io(fn -> CLI.main(["unknown", "-c", "ommand"]) end) =~ ~r/not supported/
  end

  describe "command: help" do
    test "prints the help message" do
      assert capture_io(fn -> CLI.main(["help", "whatever"]) end) =~ ~r/Usage/
    end
  end

  describe "command: new" do
    test "creates a new canvas" do
      expect(CanvasClient.HTTPClientMock, :create_canvas, fn ->
        {:ok, %Canvas{id: "8c375cd2-eeaa-42b7-9295-c790129a6598"}}
      end)

      assert capture_io(fn -> CLI.main(["new"]) end) =~
               ~r/Created a canvas with id 8c375cd2-eeaa-42b7-9295-c790129a6598/
    end
  end

  describe "command: draw" do
    test "draws a rectangle on the canvas" do
      expect(CanvasClient.HTTPClientMock, :draw_rectangle, fn attrs ->
        assert attrs.canvas_id == "8c375cd2-eeaa-42b7-9295-c790129a6598"
        assert attrs.offset_top == 1
        assert attrs.offset_left == 2
        assert attrs.height == 3
        assert attrs.width == 4
        assert attrs.fill_character == "%"
        assert attrs.outline_character == "@"

        :ok
      end)

      assert capture_io(fn ->
               CLI.main([
                 "draw",
                 "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 "--top",
                 "1",
                 "--left",
                 "2",
                 "--height",
                 "3",
                 "--width",
                 "4",
                 "--fill",
                 "%",
                 "--outline",
                 "@"
               ])
             end) =~
               ~r/Drew a rectangle on the canvas/
    end

    test "prints an error message if the canvas id is missing" do
      assert capture_io(fn ->
               CLI.main([
                 "draw",
                 "--top",
                 "1",
                 "--left",
                 "2",
                 "--height",
                 "3",
                 "--width",
                 "4",
                 "--fill",
                 "%",
                 "--outline",
                 "@"
               ])
             end) =~
               ~r/The following argument\(s\) are missing or invalid: canvas_id./
    end

    test "prints an error message if there are invalid arguments" do
      assert capture_io(fn ->
               CLI.main([
                 "draw",
                 "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 "--top",
                 "1",
                 "--foo",
                 "bar",
                 "--height",
                 "little"
               ])
             end) =~
               ~r/The following argument\(s\) are missing or invalid: --foo, --height/
    end

    test "prints the validation errors received from the server" do
      expect(CanvasClient.HTTPClientMock, :draw_rectangle, fn _attrs ->
        {:error,
         %{
           "heigth" => ["is not high enough"],
           "fill_character" => ["looks too bad", "must contain a single character"]
         }}
      end)

      output =
        capture_io(fn ->
          CLI.main([
            "draw",
            "8c375cd2-eeaa-42b7-9295-c790129a6598",
            "--top",
            "1"
          ])
        end)

      assert output =~ ~r/heigth: is not high enough/
      assert output =~ ~r/fill_character: looks too bad/
      assert output =~ ~r/fill_character: must contain a single character/
    end

    test "prints an error message if the given canvas could not be found" do
      expect(CanvasClient.HTTPClientMock, :draw_rectangle, fn _attrs ->
        {:error, :canvas_not_found}
      end)

      assert capture_io(fn ->
               CLI.main([
                 "draw",
                 "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 "--top",
                 "1"
               ])
             end) =~
               ~r/There is no canvas with the given id/
    end

    test "prints an error message if the HTTP client returns unknown error" do
      expect(CanvasClient.HTTPClientMock, :draw_rectangle, fn _attrs ->
        {:error, :unknown_error}
      end)

      assert capture_io(fn ->
               CLI.main([
                 "draw",
                 "8c375cd2-eeaa-42b7-9295-c790129a6598",
                 "--top",
                 "1"
               ])
             end) =~
               ~r/Unexpected error happened when contacting the server/
    end
  end

  describe "command: render" do
    test "renders the canvas" do
      stub(CanvasClient.HTTPClientMock, :fetch_canvas, fn canvas_id ->
        assert canvas_id == "8c375cd2-eeaa-42b7-9295-c790129a6598"

        canvas = %Canvas{
          id: canvas_id,
          rectangles: [
            %Rectangle{
              offset_top: 2,
              offset_left: 3,
              width: 5,
              height: 3,
              outline_character: "@",
              fill_character: "X"
            },
            %Rectangle{
              offset_top: 3,
              offset_left: 10,
              width: 14,
              height: 6,
              outline_character: "X",
              fill_character: "O"
            }
          ]
        }

        {:ok, canvas}
      end)

      assert capture_io(fn ->
               CLI.main(["render", "8c375cd2-eeaa-42b7-9295-c790129a6598"])
             end) =~
               ~r/Canvas rendered/
    end

    test "prints an error message if the given canvas could not be found" do
      stub(CanvasClient.HTTPClientMock, :fetch_canvas, fn _canvas_id ->
        {:error, :canvas_not_found}
      end)

      assert capture_io(fn ->
               CLI.main([
                 "render",
                 "8c375cd2-eeaa-42b7-9295-c790129a6598"
               ])
             end) =~
               ~r/There is no canvas with the given id/
    end
  end
end
