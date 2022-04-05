defmodule CanvasServer.Drawing.Canvas do
  @moduledoc """
  The schema for a canvas.
  Contains only a globally unique id and serves for grouping the related rectangles.
  """

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "canvases" do
    has_many :rectangles, CanvasServer.Drawing.Rectangle, preload_order: [asc: :id]

    timestamps()
  end
end
