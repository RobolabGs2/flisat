defmodule FlisatWeb.V1.CommentLikeControllerTest do
  use FlisatWeb.ConnCase

  import FlisatWeb.Router.Helpers

  setup %{conn: conn} do
    {:ok, %{conn: conn, user: insert(:user)}}
  end

  test "create/1 unauthorized", %{conn: conn} do
    comment = insert(:comment)

    response =
      conn
      |> post(comment_comment_like_path(conn, :create, comment.id))
      |> json_response(401)

    assert response == %{
             "errors" => [
               %{"code" => "authentication", "details" => "unauthenticated", "field" => nil}
             ]
           }
  end

  test "create/1 authorized", %{conn: conn, user: user} do
    comment = insert(:comment)

    conn
    |> as_user(user)
    |> post(comment_comment_like_path(conn, :create, comment.id))
    |> json_response(201)

    response =
      conn
      |> as_user(user)
      |> get(comment_path(conn, :show, comment.id))
      |> json_response(200)

    assert response["likes"] == 1

    _ =
      conn
      |> as_user(user)
      |> delete(comment_comment_like_path(conn, :delete, comment.id, 0))
      |> json_response(200)

    response =
      conn
      |> as_user(user)
      |> get(comment_path(conn, :show, comment.id))
      |> json_response(200)

    assert response["likes"] == 0
  end
end
