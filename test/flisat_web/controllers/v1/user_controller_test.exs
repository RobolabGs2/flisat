defmodule FlisatWeb.V1.UserControllerTest do
  use FlisatWeb.ConnCase

  import FlisatWeb.Router.Helpers

  setup %{conn: conn} do
    {:ok, %{conn: conn}}
  end

  test "create/2 creates user", %{conn: conn} do
    attrs = %{
      "nickname" => "tester",
      "password" => "QwErTy123"
    }

    response =
      conn
      |> post(user_path(conn, :create), attrs)
      |> json_response(201)

    assert response == %{
             "access_token" => response["access_token"],
             "refresh_token" => response["refresh_token"],
             "user" => %{
               "nickname" => attrs["nickname"]
             }
           }
  end
end
