defmodule CanvasServer.Repo.Migrations.CreateCanvases do
  use Ecto.Migration

  def change do
    create table(:canvases, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false

      timestamps()
    end
  end
end
