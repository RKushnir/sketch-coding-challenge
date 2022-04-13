defmodule CanvasClient.RendererTest do
  use ExUnit.Case, async: true
  alias CanvasClient.{Rectangle, Renderer}

  test "renders a rectangle with fill character and no outline character" do
    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 5,
      height: 3,
      fill_character: "X"
    }

    canvas = Renderer.new_canvas(10, 6)

    assert [
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "X", "X", "X", "X", "X", " ", " "],
             [" ", " ", " ", "X", "X", "X", "X", "X", " ", " "],
             [" ", " ", " ", "X", "X", "X", "X", "X", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
           ] == Renderer.render_rectangle(canvas, rectangle)
  end

  test "renders a rectangle with outline character and no fill character" do
    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 5,
      height: 3,
      outline_character: "#"
    }

    canvas = Renderer.new_canvas(10, 6)

    assert [
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", "#", "#", "#", "#", " ", " "],
             [" ", " ", " ", "#", " ", " ", " ", "#", " ", " "],
             [" ", " ", " ", "#", "#", "#", "#", "#", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
           ] == Renderer.render_rectangle(canvas, rectangle)
  end

  test "renders a rectangle with both fill and outline character" do
    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 5,
      height: 3,
      fill_character: "X",
      outline_character: "#"
    }

    canvas = Renderer.new_canvas(10, 6)

    assert [
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", "#", "#", "#", "#", " ", " "],
             [" ", " ", " ", "#", "X", "X", "X", "#", " ", " "],
             [" ", " ", " ", "#", "#", "#", "#", "#", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
           ] == Renderer.render_rectangle(canvas, rectangle)
  end

  test "renders a 1-character wide rectangle with both fill and outline character" do
    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 1,
      height: 3,
      fill_character: "X",
      outline_character: "#"
    }

    canvas = Renderer.new_canvas(10, 6)

    assert [
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
           ] == Renderer.render_rectangle(canvas, rectangle)
  end

  test "renders a 2-character wide rectangle with both fill and outline character" do
    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 2,
      height: 3,
      fill_character: "X",
      outline_character: "#"
    }

    canvas = Renderer.new_canvas(10, 6)

    assert [
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", "#", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", "#", " ", " ", " ", " ", " "],
             [" ", " ", " ", "#", "#", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
           ] == Renderer.render_rectangle(canvas, rectangle)
  end

  test "clips the rectangle to the size of the canvas" do
    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 5,
      height: 10,
      fill_character: "X"
    }

    canvas = Renderer.new_canvas(10, 6)

    assert [
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", " ", " ", "X", "X", "X", "X", "X", " ", " "],
             [" ", " ", " ", "X", "X", "X", "X", "X", " ", " "],
             [" ", " ", " ", "X", "X", "X", "X", "X", " ", " "],
             [" ", " ", " ", "X", "X", "X", "X", "X", " ", " "]
           ] == Renderer.render_rectangle(canvas, rectangle)
  end

  test "preserves the inner characters of the rectangle when no fill character is given" do
    other_rectangle = %Rectangle{
      offset_top: 1,
      offset_left: 1,
      width: 5,
      height: 4,
      fill_character: "X"
    }

    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 5,
      height: 3,
      outline_character: "#"
    }

    canvas = Renderer.new_canvas(10, 6) |> Renderer.render_rectangle(other_rectangle)

    assert [
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
             [" ", "X", "X", "X", "X", "X", " ", " ", " ", " "],
             [" ", "X", "X", "#", "#", "#", "#", "#", " ", " "],
             [" ", "X", "X", "#", "X", "X", " ", "#", " ", " "],
             [" ", "X", "X", "#", "#", "#", "#", "#", " ", " "],
             [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
           ] == Renderer.render_rectangle(canvas, rectangle)
  end

  test "converts a canvas to string" do
    rectangle = %Rectangle{
      offset_top: 2,
      offset_left: 3,
      width: 5,
      height: 3,
      fill_character: "X"
    }

    canvas = Renderer.new_canvas(10, 6) |> Renderer.render_rectangle(rectangle)

    assert "          \n" <>
             "          \n" <>
             "   XXXXX  \n" <>
             "   XXXXX  \n" <>
             "   XXXXX  \n" <>
             "          " == Renderer.to_string(canvas)
  end

  test "test fixture 1" do
    rectangle1 = %Rectangle{
      offset_left: 3,
      offset_top: 2,
      width: 5,
      height: 3,
      fill_character: "X",
      outline_character: "@"
    }

    rectangle2 = %Rectangle{
      offset_left: 10,
      offset_top: 3,
      width: 14,
      height: 6,
      fill_character: "O",
      outline_character: "X"
    }

    canvas =
      Renderer.new_canvas(25, 10)
      |> Renderer.render_rectangle(rectangle1)
      |> Renderer.render_rectangle(rectangle2)

    assert "                         \n" <>
             "                         \n" <>
             "   @@@@@                 \n" <>
             "   @XXX@  XXXXXXXXXXXXXX \n" <>
             "   @@@@@  XOOOOOOOOOOOOX \n" <>
             "          XOOOOOOOOOOOOX \n" <>
             "          XOOOOOOOOOOOOX \n" <>
             "          XOOOOOOOOOOOOX \n" <>
             "          XXXXXXXXXXXXXX \n" <>
             "                         " == Renderer.to_string(canvas)
  end

  test "test fixture 2" do
    rectangle1 = %Rectangle{
      offset_left: 14,
      offset_top: 0,
      width: 7,
      height: 6,
      fill_character: "."
    }

    rectangle2 = %Rectangle{
      offset_left: 0,
      offset_top: 3,
      width: 8,
      height: 4,
      outline_character: "O"
    }

    rectangle3 = %Rectangle{
      offset_left: 5,
      offset_top: 5,
      width: 5,
      height: 3,
      fill_character: "X",
      outline_character: "X"
    }

    canvas =
      Renderer.new_canvas(25, 9)
      |> Renderer.render_rectangle(rectangle1)
      |> Renderer.render_rectangle(rectangle2)
      |> Renderer.render_rectangle(rectangle3)

    assert "              .......    \n" <>
             "              .......    \n" <>
             "              .......    \n" <>
             "OOOOOOOO      .......    \n" <>
             "O      O      .......    \n" <>
             "O    XXXXX    .......    \n" <>
             "OOOOOXXXXX               \n" <>
             "     XXXXX               \n" <>
             "                         " == Renderer.to_string(canvas)
  end
end
