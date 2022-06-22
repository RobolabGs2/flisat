defmodule FlisatWeb.V1.CommentController do
  use FlisatWeb, :controller

  alias Flisat.Content

  action_fallback(FlisatWeb.FallbackController)

  defmodule IndexSearchParams do
    use Params.Schema, %{
      author_id: :integer,
      post_id: :integer,
      content: :string,
      page!: [field: :integer, default: 1],
      page_size!: [field: :integer, default: 10]
    }
  end

  defmodule CreateCommentParams do
    use Params.Schema, %{
      content!: :string,
      post_id!: :integer
    }
  end

  def index(conn, params) do
    with {:ok, params} <- ApplyParams.do_apply(IndexSearchParams, params) do
      page = Content.list_comments(params)
      render(conn, "index.json", %{page: page})
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, comment} <- Content.get_comment(id) do
      render(conn, "show.json", %{comment: comment})
    end
  end

  def create(conn, %{"current_user" => current_user} = params) do
    with {:ok, params} <- ApplyParams.do_apply(CreateCommentParams, params),
         {:ok, comment} <-
           params
           |> Map.put(:author_id, current_user.id)
           |> Content.create_comment() do
      conn
      |> put_status(:created)
      |> render("created.json", %{comment: comment})
    end
  end
end
