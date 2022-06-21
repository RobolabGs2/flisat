defmodule Flisat.Content.Post.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Flisat.Content.Post
  alias Flisat.Accounts.User

  @primary_key false
  schema "posts_likes" do
    belongs_to :post, Post
    belongs_to :user, User
  end

  def changeset(%__MODULE__{} = like, attrs) do
    like
    |> cast(attrs, [:post_id, :user_id])
    |> assoc_constraint(:post)
    |> assoc_constraint(:user)
    |> unique_constraint([:user_id, :post_id])
  end
end
