defmodule JetWeb.Router do
  use JetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JetWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/create-sandbox", PageController, :create_sandbox
    get "/inspect/:sandbox_uuid", SandboxController, :show
    get "/sandboxes/:sandbox_id", SandboxController, :fetch_requests

    post "/s/:sandbox_uuid/*any", RequestController, :create
    get "/s/:sandbox_uuid/*any", RequestController, :create
    put "/s/:sandbox_uuid/*any", RequestController, :create
    delete "/s/:sandbox_uuid/*any", RequestController, :create
    options "/s/:sandbox_uuid/*any", RequestController, :create
    trace("/s/:sandbox_uuid/*any", RequestController, :create)
    head("/s/:sandbox_uuid/*any", RequestController, :create)
  end

  # Other scopes may use custom stacks.

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: JetWeb.Telemetry
    end
  end
end
