defmodule BenarID.Web.Router do
  use BenarID.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PhoenixTokenPlug.VerifyHeader,
      salt: "member"
  end

  pipeline :protected do
    plug PhoenixTokenPlug.EnsureAuthenticated,
      handler: BenarID.Web.AuthController
  end

  scope "/", BenarID.Web do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", BenarID.Web do
    pipe_through :api

    get "/", IndexController, :index

    post "/process", APIController, :process
    get "/stats", APIController, :stats
    get "/portals", APIController, :portals
  end

  scope "/api", BenarID.Web do
    pipe_through [:api, :protected]

    get "/me", APIController, :me
    post "/rate", APIController, :rate
  end

  scope "/auth", BenarID.Web do
    pipe_through :browser

    get "/retrieve", AuthController, :retrieve
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
