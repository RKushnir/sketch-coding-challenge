defmodule CanvasServer.Drawing.Canvas do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "canvases" do
    timestamps()
  end
end
