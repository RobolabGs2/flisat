defmodule Flisat.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Flisat.Accounts.User

  @required [
    :title,
    :content,
    :author_id
  ]

  schema "posts" do
    field :content, :string
    field :title, :string
    belongs_to :author, User
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_length(:title, max: 255, count: :bytes)
    |> assoc_constraint(:author)
    |> unique_constraint(:title)
  end
end
