defmodule FlisatWeb.V1.PostView do
  use FlisatWeb, :view
  alias FlisatWeb.V1.TagView

  def render("index.json", %{page: page}) do
    %{
      entries: render_many(page.entries, __MODULE__, "show.json", as: :post),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{post: post}) do
    %{
      id: post.id,
      author_id: post.author_id,
      title: post.title,
      content: post.content,
      tags: render_many(post.tags, TagView, "show.json", as: :tag),
      likes: post.likes_count
    }
  end
end
