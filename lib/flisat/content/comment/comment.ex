defmodule Flisat.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Flisat.Content.Post
  alias Flisat.Accounts.User

  @required [
    :content,
    :author_id,
    :post_id
  ]

  schema "comments" do
    field :content, :string
    belongs_to :post, Post
    belongs_to :author, User

    many_to_many :likes, User, join_through: "comments_likes", on_replace: :delete, unique: true

    timestamps()
  end

  def changeset(%__MODULE__{} = comment, attrs) do
    comment
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> assoc_constraint(:author)
    |> assoc_constraint(:post)
  end
end
