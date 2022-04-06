defmodule CanvasClient.Renderer do
  @moduledoc """
  Renders a rectangle to a character array.
  """
  alias CanvasClient.Rectangle

  def new_canvas(width, height) do
    List.duplicate(List.duplicate(" ", width), height)
  end

  def to_string(canvas) do
    Enum.map_join(canvas, "\n", fn line -> Enum.join(line, "") end)
  end

  def render_rectangle(
        canvas,
        %Rectangle{
          height: height,
          width: width,
          fill_character: fill_character,
          outline_character: outline_character
        } = rectangle
      )
      when height > 0 and width > 0 and not (is_nil(fill_character) and is_nil(outline_character)) do
    canvas
    |> render_fill(rectangle)
    |> render_outline(rectangle)
  end

  def render_rectangle(canvas, _rectangle) do
    canvas
  end

  defp render_fill(
         canvas,
         %Rectangle{
           fill_character: fill_character,
           outline_character: nil
         } = rectangle
       )
       when is_binary(fill_character) do
    upper_bound = rectangle.offset_top
    lower_bound = rectangle.offset_top + rectangle.height - 1
    left_bound = rectangle.offset_left
    right_bound = rectangle.offset_left + rectangle.width - 1

    Enum.reduce(upper_bound..lower_bound, canvas, fn position_y, acc_y ->
      Enum.reduce(left_bound..right_bound, acc_y, fn position_x, acc_x ->
        put_character(acc_x, fill_character, position_x, position_y)
      end)
    end)
  end

  defp render_fill(
         canvas,
         %Rectangle{
           height: height,
           width: width,
           fill_character: fill_character,
           outline_character: outline_character
         } = rectangle
       )
       when is_binary(fill_character) and is_binary(outline_character) and height > 2 and
              width > 2 do
    upper_bound = rectangle.offset_top + 1
    lower_bound = rectangle.offset_top + height - 2
    left_bound = rectangle.offset_left + 1
    right_bound = rectangle.offset_left + width - 2

    Enum.reduce(upper_bound..lower_bound, canvas, fn position_y, acc_y ->
      Enum.reduce(left_bound..right_bound, acc_y, fn position_x, acc_x ->
        put_character(acc_x, fill_character, position_x, position_y)
      end)
    end)
  end

  defp render_fill(canvas, _rectangle) do
    canvas
  end

  defp render_outline(canvas, %Rectangle{outline_character: outline_character} = rectangle)
       when is_binary(outline_character) do
    upper_bound = rectangle.offset_top
    lower_bound = rectangle.offset_top + rectangle.height - 1
    left_bound = rectangle.offset_left
    right_bound = rectangle.offset_left + rectangle.width - 1

    Enum.reduce(upper_bound..lower_bound, canvas, fn position_y, acc_y ->
      Enum.reduce(left_bound..right_bound, acc_y, fn position_x, acc_x ->
        if position_y == upper_bound || position_y == lower_bound ||
             position_x == left_bound || position_x == right_bound do
          put_character(acc_x, outline_character, position_x, position_y)
        else
          acc_x
        end
      end)
    end)
  end

  defp render_outline(canvas, _rectangle) do
    canvas
  end

  defp put_character(canvas, character, position_x, position_y) do
    put_in(canvas, [Access.at(position_y), Access.at(position_x)], character)
  end
end
