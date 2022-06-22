defmodule FlisatWeb.V1.CommentControllerTest do
  use FlisatWeb.ConnCase

  import FlisatWeb.Router.Helpers

  setup %{conn: conn} do
    {:ok, %{conn: conn, user: insert(:user)}}
  end

  test "index/1 returns list items", %{conn: conn} do
    comments = insert_list(30, :comment)

    response =
      conn
      |> get(comment_path(conn, :index), %{page: 2, page_size: 5})
      |> json_response(200)

    assert response ==
             %{
               "entries" =>
                 Enum.slice(comments, 5..9)
                 |> Enum.map(fn comment ->
                   %{
                     "author_id" => comment.author_id,
                     "post_id" => comment.post_id,
                     "id" => comment.id,
                     "content" => comment.content,
                     "likes" => 0
                   }
                 end),
               "page_number" => 2,
               "page_size" => 5,
               "total_entries" => 30,
               "total_pages" => 6
             }
  end

  test "show/1 returns item", %{conn: conn} do
    comment = insert(:comment)

    response =
      conn
      |> get(comment_path(conn, :show, comment.id))
      |> json_response(200)

    assert response ==
             %{
               "author_id" => comment.author_id,
               "post_id" => comment.post_id,
               "id" => comment.id,
               "content" => comment.content,
               "likes" => 0
             }
  end

  test "show/1 not found", %{conn: conn} do
    response =
      conn
      |> get(comment_path(conn, :show, -2))
      |> json_response(404)

    assert response == %{"errors" => ["Not found"]}
  end

  test "create/1 unauthorized", %{conn: conn} do
    post = insert(:post)

    response =
      conn
      |> post(comment_path(conn, :create), %{
        post_id: post.id,
        content: "Comment for comments with examples."
      })
      |> json_response(401)

    assert response == %{
             "errors" => [
               %{"code" => "authentication", "details" => "unauthenticated", "field" => nil}
             ]
           }
  end

  test "create/1 authorized", %{conn: conn, user: user} do
    post = insert(:post)
    attrs = %{content: "Comment example.", post_id: post.id}

    response =
      conn
      |> as_user(user)
      |> post(comment_path(conn, :create), attrs)
      |> json_response(201)

    assert response["content"] == attrs.content
    assert response["post_id"] == post.id
    assert response["author_id"] == user.id
  end

  test "index/1 returns list items with filter", %{conn: conn, user: user} do
    insert_list(30, :comment)
    post = insert(:post)

    create_response =
      conn
      |> as_user(user)
      |> post(comment_path(conn, :create), %{
        content: "Content",
        post_id: post.id
      })
      |> json_response(201)

    response =
      conn
      |> get(comment_path(conn, :index), %{post_id: post.id})
      |> json_response(200)

    assert response ==
             %{
               "entries" => [
                 %{
                   "author_id" => create_response["author_id"],
                   "post_id" => create_response["post_id"],
                   "id" => create_response["id"],
                   "content" => create_response["content"],
                   "likes" => 0
                 }
               ],
               "page_number" => 1,
               "page_size" => 10,
               "total_entries" => 1,
               "total_pages" => 1
             }
  end
end
