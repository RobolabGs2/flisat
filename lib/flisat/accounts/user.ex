defmodule Flisat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Flisat.Content.Post
  alias Flisat.Content.Comment

  @required [:nickname, :password]

  schema "users" do
    field :nickname, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_many :posts, Post, foreign_key: :author_id
    has_many :comments, Comment, foreign_key: :author_id

    many_to_many :comments_likes, Comment,
      join_through: "comments_likes",
      on_replace: :delete,
      unique: true

    many_to_many :posts_likes, Post,
      join_through: "posts_likes",
      on_replace: :delete,
      unique: true

    timestamps()
  end

  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> unique_constraint(:nickname)
    |> validate_format(:password, ~r/^(?=.*\d)(?=.*[a-z])(?=.*[a-zA-Z]).{8,}/,
      message: "invalid_format"
    )
    |> put_password_hash()
  end

  defp put_password_hash(%{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
