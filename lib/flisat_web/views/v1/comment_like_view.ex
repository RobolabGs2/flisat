defmodule FlisatWeb.V1.CommentLikeView do
  use FlisatWeb, :view

  def render("index.json", %{page: page}) do
    %{
      entries: render_many(page.entries, __MODULE__, "show.json", as: :like),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{like: like}) do
    %{
      user_id: like.user_id,
      comment_id: like.comment_id
    }
  end
end
