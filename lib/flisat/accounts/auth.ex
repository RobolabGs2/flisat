defmodule Flisat.Accounts.Auth do
  alias Flisat.Accounts.User
  alias Flisat.Accounts.Services.Guardian

  def sign_user(%User{} = user), do: Guardian.sign(user)
end
