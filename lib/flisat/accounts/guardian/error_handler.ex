defmodule Flisat.Accounts.Guardian.ErrorHandler do
  use FlisatWeb, :controller

  alias Flisat.Accounts.Error
  alias FlisatWeb.ErrorView

  def auth_error(conn, {type, _reason}, _opts) do
    error =
      type
      |> to_string()
      |> Error.auth_error()

    conn
    |> put_status(401)
    |> put_view(ErrorView)
    |> render("401.json", error: error)
  end
end
