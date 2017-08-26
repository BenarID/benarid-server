defmodule BenarIDWeb.Router do
  use BenarIDWeb, :router

  import BenarIDWeb.Plugs

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
      handler: BenarIDWeb.AuthController
    plug :check_blacklisted_token
  end

  scope "/", BenarIDWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", BenarIDWeb do
    pipe_through :api

    get "/", IndexController, :index

    post "/process", APIController, :process
    get "/portals", APIController, :portals
  end

  scope "/api", BenarIDWeb do
    pipe_through [:api, :protected]

    get "/me", APIController, :me
    post "/rate", APIController, :rate
    post "/logout", APIController, :logout
  end

  scope "/auth", BenarIDWeb do
    pipe_through :browser

    get "/retrieve", AuthController, :retrieve
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
