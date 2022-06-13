defmodule Flisat.Content.Queries do
  alias Flisat.Content.Tag
  alias Flisat.Repo

  def get_tag(id) do
    Repo.find(Tag, id)
  end

  def list_tags() do
    Repo.all(Tag)
  end
end
