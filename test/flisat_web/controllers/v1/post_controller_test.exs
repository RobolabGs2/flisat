defmodule FlisatWeb.V1.PostControllerTest do
  use FlisatWeb.ConnCase

  import FlisatWeb.Router.Helpers

  setup %{conn: conn} do
    {:ok, %{conn: conn, user: insert(:user)}}
  end

  test "index/1 returns list items", %{conn: conn} do
    posts = insert_list(30, :post)

    response =
      conn
      |> get(post_path(conn, :index), %{page: 2, page_size: 5})
      |> json_response(200)

    assert response ==
             %{
               "entries" =>
                 Enum.slice(posts, 5..9)
                 |> Enum.map(fn post ->
                   %{
                     "author_id" => post.author_id,
                     "id" => post.id,
                     "title" => post.title,
                     "content" => post.content,
                     "tags" => [],
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
    post = insert(:post)

    response =
      conn
      |> get(post_path(conn, :show, post.id))
      |> json_response(200)

    assert response ==
             %{
               "author_id" => post.author_id,
               "id" => post.id,
               "title" => post.title,
               "content" => post.content,
               "tags" => [],
               "likes" => 0
             }
  end

  test "show/1 not found", %{conn: conn} do
    response =
      conn
      |> get(post_path(conn, :show, -2))
      |> json_response(404)

    assert response == %{"errors" => ["Not found"]}
  end

  test "create/1 unauthorized", %{conn: conn} do
    response =
      conn
      |> post(post_path(conn, :create), %{
        title: "example",
        content: "Post for posts with examples."
      })
      |> json_response(401)

    assert response == %{
             "errors" => [
               %{"code" => "authentication", "details" => "unauthenticated", "field" => nil}
             ]
           }
  end

  test "create/1 authorized", %{conn: conn, user: user} do
    attrs = %{title: "example", content: "Post example."}

    response =
      conn
      |> as_user(user)
      |> post(post_path(conn, :create), attrs)
      |> json_response(201)

    assert response["content"] == attrs.content
    assert response["title"] == attrs.title
    assert response["author_id"] == user.id
  end

  test "create/1 duplicated title", %{conn: conn, user: user} do
    insert(:post, title: "exists")
    attrs = %{title: "exists", content: "Example."}

    response =
      conn
      |> as_user(user)
      |> post(post_path(conn, :create), attrs)
      |> json_response(422)

    assert response == %{"errors" => [%{"code" => "has already been taken", "field" => "title"}]}
  end

  test "index/1 returns list items with filter", %{conn: conn, user: user} do
    insert_list(30, :post)
    tag = insert(:tag)

    create_response =
      conn
      |> as_user(user)
      |> post(post_path(conn, :create), %{title: "Title", content: "Content", tag_ids: [tag.id]})
      |> json_response(201)

    response =
      conn
      |> get(post_path(conn, :index), %{tag_ids: [tag.id]})
      |> json_response(200)

    assert response ==
             %{
               "entries" => [
                 %{
                   "author_id" => create_response["author_id"],
                   "id" => create_response["id"],
                   "title" => create_response["title"],
                   "content" => create_response["content"],
                   "tags" => [
                     %{
                       "title" => tag.title,
                       "description" => tag.description,
                       "id" => tag.id
                     }
                   ],
                   "likes" => 1
                 }
               ],
               "page_number" => 1,
               "page_size" => 10,
               "total_entries" => 1,
               "total_pages" => 1
             }
  end
end
