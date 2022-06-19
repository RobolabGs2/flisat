defmodule Flisat.Content.Post.Commands do
  alias Flisat.Content.Tag
  alias Flisat.Content.Post
  alias Flisat.Repo
  import Ecto.Query

  def create(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> changeset_post_tags(attrs)
    |> Repo.insert()
  end

  def update(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> changeset_post_tags(attrs)
    |> Repo.update()
  end

  def delete(%Post{} = post) do
    Repo.delete(post)
  end

  defp changeset_post_tags(post, %{tag_ids: tag_ids}) when is_list(tag_ids) do
    tags =
      Tag
      |> where([tag], tag.id in ^tag_ids)
      |> Repo.all()

    post
    |> Post.changeset_update_tags(tags)
  end

  defp changeset_post_tags(post, _ignore) do
    post
  end
end
