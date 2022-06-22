defmodule FlisatWeb.Router do
  use FlisatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FlisatWeb do
    pipe_through :api
  end

  pipeline :user_auth do
    plug Flisat.Accounts.Guardian.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
    plug FlisatWeb.CurrentUserPlug
  end

  scope "/api/v1", FlisatWeb.V1 do
    pipe_through [:api]

    post "/users", UserController, :create
    resources "/tags", TagController, only: [:index, :show]
    resources "/posts", PostController, only: [:index, :show]

    pipe_through [:user_auth, :ensure_auth]
    resources "/tags", TagController, only: [:create, :update]
    resources "/posts", PostController, only: [:create, :update]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: FlisatWeb.Telemetry
    end
  end
end
