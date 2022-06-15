defmodule Flisat.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Flisat.Accounts.User
  alias Flisat.Content.Tag

  @required [
    :title,
    :content,
    :author_id
  ]

  schema "posts" do
    field :content, :string
    field :title, :string

    belongs_to :author, User
    many_to_many :tags, Tag, join_through: "post_tags", on_replace: :delete

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

  def changeset_update_tags(post, tags) do
    post
    |> cast(%{}, @required)
    |> put_assoc(:tags, tags)
  end
end
