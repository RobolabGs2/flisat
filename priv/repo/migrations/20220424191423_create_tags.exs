defmodule Flisat.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string
      add :description, :string

      timestamps()
    end

    create unique_index(:tags, [:title])
  end
end
