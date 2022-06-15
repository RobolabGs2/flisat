defmodule Flisat.Content.Queries do
  alias Flisat.Content.Tag
  alias Flisat.Content.Post
  alias Flisat.Repo

  def get_tag(id) do
    Repo.find(Tag, id)
  end

  def list_tags() do
    Repo.all(Tag)
  end

  def get_post(id) do
    Repo.find(Post, id)
  end

  def list_posts() do
    Repo.all(Post)
  end
end
