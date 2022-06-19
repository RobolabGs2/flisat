defmodule Flisat.Content.Tag.Queries do
  alias Flisat.Content.Tag
  alias Flisat.Repo

  def get(id) do
    Repo.find(Tag, id)
  end

  def list() do
    Repo.all(Tag)
  end
end
