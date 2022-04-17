defmodule Flisat.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Flisat.Repo,
      # Start the Telemetry supervisor
      FlisatWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Flisat.PubSub},
      # Start the Endpoint (http/https)
      FlisatWeb.Endpoint
      # Start a worker by calling: Flisat.Worker.start_link(arg)
      # {Flisat.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Flisat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlisatWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
