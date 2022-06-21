defmodule Flisat.Content.Post.Commands do
  alias Flisat.Content.Post
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
end
