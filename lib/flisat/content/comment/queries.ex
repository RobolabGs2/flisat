defmodule Flisat.Content.Comment.Queries do
  alias Flisat.Content.Comment
  alias Flisat.Repo

  def get(id) do
    Repo.find(Comment, id)
  end

  def list() do
    Repo.all(Comment)
  end
end
