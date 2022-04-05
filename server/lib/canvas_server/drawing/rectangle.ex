defmodule CanvasServer.Drawing.Rectangle do
  @moduledoc """
  The schema for a rectangle.
  Contains the coordinates and sizes of a rectangle, the fill and the outline character.
  All coordinates and sizes need to be non-negative integers.
  Fill and outline character must be single-character strings,
  and at least one of them must be present.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "rectangles" do
    belongs_to :canvas, CanvasServer.Drawing.Canvas, type: :binary_id
    field :offset_top, :integer
    field :offset_left, :integer
    field :height, :integer
    field :width, :integer
    field :fill_character, :string
    field :outline_character, :string

    timestamps()
  end

  def changeset(canvas, attrs) do
    canvas
    |> Ecto.build_assoc(:rectangles)
    |> cast(attrs, [
      :offset_top,
      :offset_left,
      :height,
      :width,
      :fill_character,
      :outline_character
    ])
    |> validate_required([
      :offset_top,
      :offset_left,
      :height,
      :width
    ])
    |> validate_at_least_one_required([
      :fill_character,
      :outline_character
    ])
    |> validate_measurement([
      :offset_top,
      :offset_left,
      :height,
      :width
    ])
    |> validate_pixel_character([
      :fill_character,
      :outline_character
    ])
  end

  defp validate_at_least_one_required(changeset, fields) do
    if Enum.all?(fields, &(get_field(changeset, &1) in ["", nil])) do
      add_error(
        changeset,
        :fill_character,
        "Either fill_character or outline_character must be present"
      )
    else
      changeset
    end
  end

  defp validate_measurement(changeset, fields) do
    fields = List.wrap(fields)

    Enum.reduce(fields, changeset, fn field, acc ->
      validate_number(acc, field, greater_than_or_equal_to: 0)
    end)
  end

  defp validate_pixel_character(changeset, fields) do
    fields = List.wrap(fields)

    Enum.reduce(fields, changeset, fn field, acc ->
      validate_length(acc, field, is: 1)
    end)
  end
end
