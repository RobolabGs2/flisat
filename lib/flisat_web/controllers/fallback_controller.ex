defmodule FlisatWeb.FallbackController do
  use FlisatWeb, :controller

  alias Ecto.Changeset
  alias FlisatWeb.ErrorView

  def call(%Conn{} = conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json", %{})
  end

  def call(%Conn{} = conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(ErrorView)
    |> render("403.json", message: "You are not authorized to perform this action.")
  end

  def call(%Conn{} = conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("422.json", changeset: changeset)
  end
end
