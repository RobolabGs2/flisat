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

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> assoc_constraint(:author)
    |> assoc_constraint(:post)
  end
end
