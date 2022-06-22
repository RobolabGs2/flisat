defmodule FlisatWeb.V1.CommentView do
  use FlisatWeb, :view

  def render("index.json", %{page: page}) do
    %{
      entries: render_many(page.entries, __MODULE__, "show.json", as: :comment),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{comment: comment}) do
    %{
      id: comment.id,
      author_id: comment.author_id,
      post_id: comment.post_id,
      content: comment.content,
      likes: comment.likes_count
    }
  end

  def render("created.json", %{comment: comment}) do
    %{
      id: comment.id,
      author_id: comment.author_id,
      post_id: comment.post_id,
      content: comment.content
    }
  end
end
