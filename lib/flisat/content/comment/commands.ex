defmodule Flisat.Content.Comment.Commands do
  alias Flisat.Content.Comment
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

end
