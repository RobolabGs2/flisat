defmodule Flisat.Content.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Flisat.Content.Post

  @required [:title, :description]

  schema "tags" do
    field :title, :string
    field :description, :string

    many_to_many :posts, Post, join_through: "post_tags", on_replace: :delete
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = tag, attrs) do
    tag
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint(:title)
  end
end
