defmodule Flisat.Content.Comment.Commands do
  alias Flisat.Content.Comment
  alias Flisat.Content.Comment.Like
  alias Flisat.Repo
  import Ecto.Query

  def create(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def like(comment_id, user_id) do
    %Like{}
    |> Like.changeset(%{comment_id: comment_id, user_id: user_id})
    |> Repo.insert()
  end

  def unlike(comment_id, user_id) do
    Like
    |> where(comment_id: ^comment_id)
    |> where(user_id: ^user_id)
    |> Repo.delete_all()
  end
end
