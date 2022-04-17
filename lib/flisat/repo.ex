defmodule Flisat.Repo do
  use Ecto.Repo,
    otp_app: :flisat,
    adapter: Ecto.Adapters.Postgres
end
