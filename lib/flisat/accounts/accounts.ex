defmodule Flisat.Accounts do
  alias Flisat.Accounts.Commands
  alias Flisat.Accounts.Queries

  # Commands
  defdelegate create_user(attrs), to: Commands, as: :create_user
  defdelegate delete_user(user), to: Commands, as: :delete_user
  defdelegate update_user(user, attrs), to: Commands, as: :update_user

  # Queries
  defdelegate get_user(id), to: Queries, as: :get_user
  defdelegate list_users(), to: Queries, as: :list_users
end
