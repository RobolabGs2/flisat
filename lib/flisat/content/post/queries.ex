defmodule Flisat.Content.Post.Queries do
  alias Flisat.Content.Post
  alias Flisat.Repo

  import Ecto.Query

  def get(id) do
    Repo.find(Post, id)
  end

  def list(params) do
    Post
    |> with_author(params)
    |> with_tags(params)
    |> with_title(params)
    |> with_content(params)
    |> Repo.paginate(params)
  end

  defp with_author(query, %{author_id: author_id}) do
    query |> where(author_id: ^author_id)
  end

  defp with_author(query, _), do: query

  # defp with_tags(query, %{tags_id: tags_id}) do
    # query |> where(author_id: ^author_id) TODO
  # end

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
end
