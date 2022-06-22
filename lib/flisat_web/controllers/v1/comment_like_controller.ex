defmodule FlisatWeb.V1.CommentLikeController do
  use FlisatWeb, :controller

  alias Flisat.Content

  action_fallback(FlisatWeb.FallbackController)

  defmodule CreateLikeParams do
    use Params.Schema, %{
      comment_id!: :integer
    }
  end

  def create(conn, %{"current_user" => current_user} = params) do
    with {:ok, params} <- ApplyParams.do_apply(CreateLikeParams, params),
         {:ok, like} <- Content.like_comment(params.comment_id, current_user.id) do
      conn
      |> put_status(:created)
      |> render("show.json", %{like: like})
    end
  end

  def delete(conn, %{"current_user" => current_user} = params) do
    with {:ok, params} <- ApplyParams.do_apply(CreateLikeParams, params),
         {1, nil} <- Content.unlike_comment(params.comment_id, current_user.id) do
      conn
      |> put_status(200)
      |> render("show.json", %{like: %{user_id: current_user.id, comment_id: params.comment_id}})
    end
  end
end
