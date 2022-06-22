defmodule Flisat.Content.Post.Queries do
  alias Flisat.Content.Post
  alias Flisat.Repo

  import Ecto.Query

  def get(id) do
    Post
    |> preload_relations()
    |> likes_count()
    |> Repo.find(id)
  end

  def list(params) do
    Post
    |> with_tags(params)
    |> with_rating(params)
    |> with_author(params)
    |> with_title(params)
    |> with_content(params)
    |> with_date(params)
    |> preload_relations()
    |> order_by(asc: :id)
    |> Repo.paginate(params)
  end

  defp with_author(query, %{author_id: author_id}) do
    query |> where(author_id: ^author_id)
  end

  defp with_author(query, _), do: query

  defp with_tags(query, %{tag_ids: tag_ids}) do
    query
    |> join(:left, [post], tag in assoc(post, :tags))
    |> where([_post, tag], tag.id in ^tag_ids)
    |> group_by([post, tag], post.id)
    |> having([_post, tag], count(tag.id) == ^length(tag_ids))
  end

  defp with_tags(query, _), do: query

  defp with_title(query, %{title: title}) do
    title = "%" <> String.trim(title) <> "%"
    query |> where([post], ilike(post.title, ^title))
  end

  defp with_title(query, _), do: query

  defp with_content(query, %{content: content}) do
    content = "%" <> String.trim(content) <> "%"
    query |> where([post], ilike(post.content, ^content))
  end

  defp with_content(query, _), do: query

  defp with_date(query, %{start_date: start_date, end_date: end_date}) do
    query
    |> where(
      [post],
      fragment(
        "?::date BETWEEN ?::date and ?::date",
        post.inserted_at,
        ^start_date,
        ^end_date
      )
    )
  end

  defp with_date(query, _), do: query

  defp with_rating(query, %{min_likes: min_likes, max_likes: max_likes}) do
    query
    |> join(:left, [post], like in assoc(post, :likes))
    |> group_by([post, like], post.id)
    |> select_merge([post, like], %{likes_count: count(like.id)})
    |> having([_post, like], count(like.id) >= ^min_likes and count(like.id) <= ^max_likes)
  end

  defp with_rating(query, %{min_likes: min_likes}) do
    query
    |> join(:left, [post], like in assoc(post, :likes))
    |> group_by([post, like], post.id)
    |> select_merge([post, like], %{likes_count: count(like.id)})
    |> having([_post, like], count(like.id) >= ^min_likes)
  end

  defp with_rating(query, %{max_likes: max_likes}) do
    query
    |> join(:left, [post], like in assoc(post, :likes))
    |> group_by([post, like], post.id)
    |> select_merge([post, like], %{likes_count: count(like.id)})
    |> having([_post, like], count(like.id) <= ^max_likes)
  end

  defp with_rating(query, _), do: query

  defp likes_count(query) do
    query
    |> join(:left, [post], like in assoc(post, :likes))
    |> group_by([post, like], post.id)
    |> select_merge([post, like], %{likes_count: count(like.id)})
  end

  defp preload_relations(query) do
    query
    |> preload(:tags)
  end
end
