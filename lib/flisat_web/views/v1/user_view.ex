defmodule FlisatWeb.V1.UserView do
  use FlisatWeb, :view

  def render("create.json", %{
        user: user,
        access_token: access_token,
        refresh_token: refresh_token
      }) do
    %{
      access_token: access_token,
      refresh_token: refresh_token,
      user: %{
        nickname: user.nickname
      }
    }
  end
end
