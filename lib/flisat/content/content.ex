defmodule Flisat.Content do
  alias Flisat.Content.Tag
  alias Flisat.Content.Post
  alias Flisat.Content.Comment

  # Tags
  defdelegate create_tag(attrs), to: Tag.Commands, as: :create
  defdelegate delete_tag(tag), to: Tag.Commands, as: :delete
  defdelegate update_tag(tag, attrs), to: Tag.Commands, as: :update

  defdelegate get_tag(id), to: Tag.Queries, as: :get
  defdelegate list_tags(params), to: Tag.Queries, as: :list

  # Posts
  defdelegate create_post(attrs), to: Post.Commands, as: :create
  defdelegate delete_post(post), to: Post.Commands, as: :delete
  defdelegate update_post(post, attrs), to: Post.Commands, as: :update
  defdelegate like_post(post, user), to: Post.Commands, as: :like

  defdelegate get_post(id), to: Post.Queries, as: :get
  defdelegate list_posts(params), to: Post.Queries, as: :list

  # Comments
  defdelegate create_comment(attrs), to: Comment.Commands, as: :create
  defdelegate delete_comment(comment), to: Comment.Commands, as: :delete
  defdelegate update_comment(comment, attrs), to: Comment.Commands, as: :update
  defdelegate like_comment(comment_id, user_id), to: Comment.Commands, as: :like
  defdelegate unlike_comment(comment_id, user_id), to: Comment.Commands, as: :unlike

  defdelegate get_comment(id), to: Comment.Queries, as: :get
  defdelegate list_comments(params), to: Comment.Queries, as: :list
end
