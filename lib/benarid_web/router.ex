defmodule BenarIDWeb.Router do
  use BenarIDWeb, :router

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
      salt: "member",
      max_age: Application.get_env(:benarid, BenarIDWeb.Endpoint)[:token_max_age]
  end

  pipeline :protected do
    plug PhoenixTokenPlug.EnsureAuthenticated,
      handler: BenarIDWeb.AuthController
    plug PhoenixTokenPlug.CustomValidation,
      validate_fn: &BenarIDWeb.AuthController.not_blacklisted?/3,
      handler: BenarIDWeb.AuthController
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
