defmodule BenarIDWeb.Router do
  use BenarIDWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Phoenix.Token.Plug.VerifyHeader,
      salt: "member"
  end

  pipeline :protected do
    plug Phoenix.Token.Plug.EnsureAuthenticated,
      handler: BenarIDWeb.AuthController
  end

  scope "/api", BenarIDWeb do
    pipe_through :api

    get "/", IndexController, :index
  end

  scope "/api", BenarIDWeb do
    pipe_through [:api, :protected]

    # Protected routes go here
  end

  scope "/auth", BenarIDWeb do
    pipe_through :browser

    get "/retrieve", AuthController, :retrieve
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
