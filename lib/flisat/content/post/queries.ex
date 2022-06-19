defmodule Flisat.Content.Post.Queries do
  alias Flisat.Content.Post
  alias Flisat.Repo

  def get(id) do
    Repo.find(Post, id)
  end

  def list() do
    Repo.all(Post)
  end
end
