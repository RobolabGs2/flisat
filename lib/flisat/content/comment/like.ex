defmodule Flisat.Content.Comment.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Flisat.Content.Comment
  alias Flisat.Accounts.User

  @primary_key false
  schema "comments_likes" do
    belongs_to :comment, Comment
    belongs_to :user, User
  end

  def changeset(%__MODULE__{} = like, attrs) do
    like
    |> cast(attrs, [:comment_id, :user_id])
    |> assoc_constraint(:comment)
    |> assoc_constraint(:user)
    |> unique_constraint([:user_id, :comment_id])
  end
end
