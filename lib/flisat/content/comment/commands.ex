defmodule Flisat.Content.Comment.Commands do
  alias Flisat.Content.Comment
  alias Flisat.Content.Comment.Like
  alias Flisat.Accounts.User
  alias Flisat.Repo

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

  def like(%Comment{} = comment, %User{} = user) do
    %Like{}
    |> Like.changeset(%{comment_id: comment.id, user_id: user.id})
    |> Repo.insert()
  end
end
