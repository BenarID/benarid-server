defmodule API.Router do
  use API.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", API do
    pipe_through :api

    get "/", IndexController, :index
  end
end
