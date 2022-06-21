defmodule Flisat.Content.Tag.Queries do
  alias Flisat.Content.Tag
  alias Flisat.Repo

  def get(id) do
    Repo.find(Tag, id)
  end

  def list(params) do
    Repo.paginate(Tag, params)
  end
end
