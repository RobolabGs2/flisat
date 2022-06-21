defmodule Flisat.Content.Post.Queries do
  alias Flisat.Content.Post
  alias Flisat.Repo

  import Ecto.Query

  def get(id) do
    Repo.find(Post, id)
  end

  def list(params) do
    Post
    |> with_tags(params)
    |> with_author(params)
    |> with_title(params)
    |> with_content(params)
    |> with_date(params)
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
    query |> where(
      [post],
      fragment(
        "?::date BETWEEN ?::date and ?::date",
        post.inserted_at, ^start_date, ^end_date
    ))
  end

  defp with_date(query, _), do: query
end
