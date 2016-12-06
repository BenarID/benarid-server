defmodule BenarIDWeb.Router do
  use BenarIDWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PhoenixTokenPlug.VerifyHeader,
      salt: "member"
  end

  pipeline :protected do
    plug PhoenixTokenPlug.EnsureAuthenticated,
      handler: BenarIDWeb.AuthController
  end

  scope "/api", BenarIDWeb do
    pipe_through :api

    get "/", IndexController, :index

    post "/process", APIController, :process
    get "/stats", APIController, :stats
  end

  scope "/api", BenarIDWeb do
    pipe_through [:api, :protected]

    get "/me", APIController, :me
    post "/rate", APIController, :rate
  end

  scope "/auth", BenarIDWeb do
    pipe_through :browser

    get "/retrieve", AuthController, :retrieve
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
