defmodule Flisat.Content.Tag.Commands do
  alias Flisat.Content.Tag
  alias Flisat.Repo

  def create(attrs) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Tag{} = tag) do
    Repo.delete(tag)
  end
end
