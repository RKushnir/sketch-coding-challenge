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

  describe "rectangles" do
    alias CanvasServer.Drawing.{Canvas, Rectangle}

    test "draw_rectangle/2 with valid data creates a rectangle" do
      canvas = Drawing.create_canvas!()

      assert {:ok,
              %Rectangle{
                offset_top: 1,
                offset_left: 2,
                height: 3,
                width: 4,
                fill_character: "#",
                outline_character: "&"
              }} =
               Drawing.draw_rectangle(canvas, %{
                 offset_top: "1",
                 offset_left: "2",
                 height: "3",
                 width: "4",
                 fill_character: "#",
                 outline_character: "&"
               })
    end

    test "draw_rectangle/2 returns error if both fill_character and outline_character are missing" do
      canvas = Drawing.create_canvas!()

      assert {:error, changeset} =
               Drawing.draw_rectangle(canvas, %{
                 offset_top: "1",
                 offset_left: "2",
                 height: "3",
                 width: "4",
                 fill_character: ""
               })

      assert errors_on(changeset)[:fill_character] == [
               "Either fill_character or outline_character must be present"
             ]
    end

    test "draw_rectangle/2 returns error if a coordinate or size is negative" do
      canvas = Drawing.create_canvas!()

      assert {:error, changeset} =
               Drawing.draw_rectangle(canvas, %{
                 offset_top: "-1",
                 offset_left: "-2",
                 height: "-3",
                 width: "-4",
                 fill_character: "#"
               })

      assert errors_on(changeset)[:offset_top] == [
               "must be greater than or equal to 0"
             ]

      assert errors_on(changeset)[:offset_left] == [
               "must be greater than or equal to 0"
             ]

      assert errors_on(changeset)[:height] == [
               "must be greater than or equal to 0"
             ]

      assert errors_on(changeset)[:width] == [
               "must be greater than or equal to 0"
             ]
    end

    test "draw_rectangle/2 returns error if a fill or outline character contains not 1 character" do
      canvas = Drawing.create_canvas!()

      assert {:error, changeset} =
               Drawing.draw_rectangle(canvas, %{
                 offset_top: "1",
                 offset_left: "2",
                 height: "3",
                 width: "4",
                 fill_character: "**",
                 outline_character: "%%"
               })

      assert errors_on(changeset)[:fill_character] == [
               "should be 1 character(s)"
             ]

      assert errors_on(changeset)[:outline_character] == [
               "should be 1 character(s)"
             ]
    end
  end
end
