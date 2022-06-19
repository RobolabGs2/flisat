defmodule Flisat.Repo.Migrations.AddLikes do
  use Ecto.Migration

  def change do
    create table("posts_likes", primary_key: false) do
      add :post_id, references(:posts)
      add :user_id, references(:users)
    end

    create(index(:posts_likes, [:post_id]))
    create(index(:posts_likes, [:user_id]))
    create unique_index(:posts_likes, [:post_id, :user_id], name: :post_id_user_id_unique_index)

    create table("comments_likes", primary_key: false) do
      add :comment_id, references(:comments)
      add :user_id, references(:users)
    end

    create(index(:comments_likes, [:comment_id]))
    create(index(:comments_likes, [:user_id]))
    create unique_index(:comments_likes, [:comment_id, :user_id], name: :comment_id_user_id_unique_index)
  end
end
