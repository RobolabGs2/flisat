defmodule Flisat.Content.Comment.Queries do
  alias Flisat.Content.Comment
  alias Flisat.Repo
  import Ecto.Query

  def get(id) do
    Comment
    |> likes_count()
    |> Repo.find(id)
  end

  def list(params) do
    Comment
    |> with_post(params)
    |> with_author(params)
    |> with_content(params)
    |> likes_count()
    |> order_by(asc: :id)
    |> Repo.paginate(params)
  end

  defp with_post(query, %{post_id: post_id}) do
    query
    |> where(post_id: ^post_id)
  end

  defp with_post(query, _), do: query

  defp with_author(query, %{author_id: author_id}) do
    query |> where(author_id: ^author_id)
  end

  defp with_author(query, _), do: query

  defp with_content(query, %{content: content}) do
    content = "%" <> String.trim(content) <> "%"
    query |> where([post], ilike(post.content, ^content))
  end

  defp with_content(query, _), do: query

  defp likes_count(query) do
    query
    |> join(:left, [post], like in assoc(post, :likes))
    |> group_by([post, like], post.id)
    |> select_merge([post, like], %{likes_count: count(like.id)})
  end
end
