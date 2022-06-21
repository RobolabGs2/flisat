defmodule FlisatWeb.V1.TagController do
  use FlisatWeb, :controller

  alias Flisat.Content

  action_fallback(FlisatWeb.FallbackController)

  defmodule IndexSearchParams do
    use Params.Schema, %{
      page!: [field: :integer, default: 1],
      page_size!: [field: :integer, default: 10]
    }
  end

  defmodule CreateTagParams do
    use Params.Schema, %{
      title!: :string,
      description!: :string
    }
  end

  def index(conn, params) do
    with {:ok, params} <- ApplyParams.do_apply(IndexSearchParams, params) do
      page = Content.list_tags(params)
      render(conn, "index.json", %{page: page})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, tag} <- Content.get_tag(id) do
      render(conn, "show.json", %{tag: tag})
    end
  end

  def create(conn, %{"current_user" => _current_user} = params) do
    with {:ok, params} <- ApplyParams.do_apply(CreateTagParams, params),
         {:ok, tag} <- Content.create_tag(params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{tag: tag})
    end
  end
end
