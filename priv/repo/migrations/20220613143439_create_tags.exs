defmodule Flisat.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string, size: 255, null: false
      add :description, :string, null: false

      timestamps()
    end

    create unique_index(:tags, [:title])
  end
end
