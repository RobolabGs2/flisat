defmodule Flisat.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Flisat.Accounts.User
  alias Flisat.Content.Tag
  alias Flisat.Content.Comment

  @required [
    :title,
    :content,
    :author_id
  ]

  schema "posts" do
    field :content, :string
    field :title, :string

    belongs_to :author, User
    many_to_many :tags, Tag, join_through: "post_tags", on_replace: :delete, unique: true
    many_to_many :likes, User, join_through: "posts_likes", on_replace: :delete, unique: true
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = post, attrs) do
    post
    |> Flisat.Repo.preload(:tags)
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_length(:title, max: 255, count: :bytes)
    |> assoc_constraint(:author)
    |> unique_constraint(:title)
    |> put_assoc(:tags, Map.get(attrs, :tags, []))
  end
end
