defmodule Flisat.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text, null: false
      add :post_id, references(:posts, on_delete: :nothing)
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:comments, [:post_id])
    create index(:comments, [:author_id])
  end
end
