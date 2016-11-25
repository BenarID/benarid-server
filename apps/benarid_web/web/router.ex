defmodule BenarIDWeb.Router do
  use BenarIDWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BenarIDWeb do
    pipe_through :api

    get "/", IndexController, :index
  end

  scope "/auth", BenarIDWeb do
    pipe_through :browser

    get "/retrieve", AuthController, :retrieve
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
