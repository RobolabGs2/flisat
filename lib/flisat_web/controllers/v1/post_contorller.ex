defmodule FlisatWeb.V1.PostController do
  use FlisatWeb, :controller

  alias Flisat.Content

  action_fallback(FlisatWeb.FallbackController)

  defmodule IndexSearchParams do
    use Params.Schema, %{
      author_id: :integer,
      tag_ids: {:array, :integer},
      title: :string,
      content: :string,
      start_date: :date,
      end_date: :date,
      min_likes: [field: :integer, default: 0],
      max_likes: :integer,
      page!: [field: :integer, default: 1],
      page_size!: [field: :integer, default: 10]
    }
  end

  defmodule CreatePostParams do
    use Params.Schema, %{
      title!: :string,
      content!: :string,
      tag_ids: [field: {:array, :integer}, default: []]
    }
  end

  def index(conn, params) do
    with {:ok, params} <- ApplyParams.do_apply(IndexSearchParams, params) do
      page = Content.list_posts(params)
      render(conn, "index.json", %{page: page})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- Content.get_post(id) do
      render(conn, "show.json", %{post: post})
    end
  end

  def create(conn, %{"current_user" => current_user} = params) do
    with {:ok, params} <- ApplyParams.do_apply(CreatePostParams, params),
         tags <-
           Enum.map(
             params.tag_ids,
             fn id ->
               {:ok, tag} = Content.get_tag(id)
               tag
             end
           ),
         {:ok, post} <-
           params
           |> Map.put(:author_id, current_user.id)
           |> Map.put(:tags, tags)
           |> Content.create_post() do
      conn
      |> put_status(:created)
      |> render("show.json", %{post: post})
    end
  end
end
