defmodule Flisat.Factories do
  use ExMachina.Ecto, repo: Flisat.Repo

  use Flisat.Factories.{
    Accounts.UserFactory,
    Content
  }
end
