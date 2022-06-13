defmodule Flisat.Accounts.Queries do
  alias Flisat.Accounts.User
  alias Flisat.Repo

  def get_user(id) do
    Repo.find(User, id)
  end

  def list_users() do
    Repo.all(User)
  end
end
