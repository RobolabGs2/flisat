defmodule FlisatWeb.V1.TagView do
  use FlisatWeb, :view

  def render("index.json", %{page: page}) do
    %{
      entries: render_many(page.entries, __MODULE__, "show.json", as: :tag),
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{tag: tag}) do
    %{
      id: tag.id,
      title: tag.title,
      description: tag.description
    }
  end
end
