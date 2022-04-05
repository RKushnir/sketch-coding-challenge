defmodule CanvasServer.Drawing do
  @moduledoc """
  The context for creating and retrieving drawings.
  """

  import Ecto.Query, warn: false
  alias CanvasServer.Repo

  alias CanvasServer.Drawing.{Canvas, Rectangle}

  @doc """
  Gets a single canvas.

  Raises `Ecto.NoResultsError` if the Canvas does not exist.

  ## Examples

      iex> get_canvas!(123)
      %Canvas{}

      iex> get_canvas!(456)
      ** (Ecto.NoResultsError)

  """
  def get_canvas!(id), do: Repo.get!(Canvas, id)

  @doc """
  Creates a canvas.

  ## Examples

      iex> create_canvas!()
      %Canvas{}

  """
  def create_canvas!() do
    Repo.insert!(%Canvas{})
  end

  @doc """
  Creates a rectangle associated with the given canvas.

  ## Examples

      iex> draw_rectangle!()
      {:ok, %Rectangle{}}

  """
  def draw_rectangle(canvas, attrs) do
    canvas
    |> Rectangle.changeset(attrs)
    |> Repo.insert()
  end
end
