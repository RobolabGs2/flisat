defmodule FlisatWeb.V1.TagControllerTest do
  use FlisatWeb.ConnCase

  import FlisatWeb.Router.Helpers

  setup %{conn: conn} do
    {:ok, %{conn: conn}}
  end

  test "index/1 returns list items", %{conn: conn} do
    tags = insert_list(30, :tag)

    response =
      conn
      |> get(tag_path(conn, :index), %{page: 2, page_size: 5})
      |> json_response(200)

    assert response ==
             %{
               "entries" =>
                 Enum.slice(tags, 5..9)
                 |> Enum.map(fn tag ->
                   %{
                     "id" => tag.id,
                     "title" => tag.title,
                     "description" => tag.description
                   }
                 end),
               "page_number" => 2,
               "page_size" => 5,
               "total_entries" => 30,
               "total_pages" => 6
             }
  end

  test "show/1 returns item", %{conn: conn} do
    tag = insert(:tag)

    response =
      conn
      |> get(tag_path(conn, :show, tag.id))
      |> json_response(200)

    assert response ==
             %{
               "id" => tag.id,
               "title" => tag.title,
               "description" => tag.description
             }
  end

  test "show/1 not found", %{conn: conn} do
    response =
      conn
      |> get(tag_path(conn, :show, -2))
      |> json_response(404)

    assert response == %{"errors" => ["Not found"]}
  end

  test "create/1 unauthorized", %{conn: conn} do
    response =
      conn
      |> post(tag_path(conn, :create), %{
        title: "example",
        description: "Tag for posts with examples."
      })
      |> json_response(401)

    assert response == %{
             "errors" => [
               %{"code" => "authentication", "details" => "unauthenticated", "field" => nil}
             ]
           }
  end

  test "create/1 authorized", %{conn: conn} do
    user = insert(:user)
    attrs = %{title: "example", description: "Tag for posts with examples."}

    response =
      conn
      |> as_user(user)
      |> post(tag_path(conn, :create), attrs)
      |> json_response(201)

    assert response["description"] == attrs.description
    assert response["title"] == attrs.title
  end

  test "create/1 duplicated title", %{conn: conn} do
    user = insert(:user)
    insert(:tag, title: "exists")
    attrs = %{title: "exists", description: "Tag for posts with examples."}

    response =
      conn
      |> as_user(user)
      |> post(tag_path(conn, :create), attrs)
      |> json_response(422)

    assert response == %{"errors" => [%{"code" => "has already been taken", "field" => "title"}]}
  end
end
