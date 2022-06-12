defmodule Flisat.Blog.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> unique_constraint(:title)
  end
end
