defmodule CanvasServer.Drawing.Canvas do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "canvases" do
    has_many :rectangles, CanvasServer.Drawing.Rectangle, preload_order: [asc: :id]

    timestamps()
  end
end
