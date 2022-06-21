defmodule Flisat.Content.Post.Commands do
  alias Flisat.Accounts.User
  alias Flisat.Content.Post
  alias Flisat.Content.Post.Like
  alias Flisat.Repo

  def create(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Post{} = post) do
    Repo.delete(post)
  end

  def like(%Post{} = post, %User{} = user) do
    %Like{}
    |> Like.changeset(%{post_id: post.id, user_id: user.id})
    |> Repo.insert()
  end
end
