defmodule Flisat.Content.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @required [:title, :description]

  schema "tags" do
    field :title, :string
    field :description, :string

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
