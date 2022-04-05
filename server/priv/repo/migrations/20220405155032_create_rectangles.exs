defmodule CanvasServer.Repo.Migrations.CreateRectangles do
  use Ecto.Migration

  def change do
    create table(:rectangles) do
      add :canvas_id, references(:canvases, type: :uuid, on_delete: :delete_all), null: false
      add :offset_top, :integer, null: false
      add :offset_left, :integer, null: false
      add :height, :integer, null: false
      add :width, :integer, null: false
      add :fill_character, :string, size: 1
      add :outline_character, :string, size: 1

      timestamps()
    end

    create index(:rectangles, [:canvas_id])

    create constraint(:rectangles, :either_fill_or_outline_must_be_present,
             check: "fill_character IS NOT NULL OR outline_character IS NOT NULL"
           )
  end
end
