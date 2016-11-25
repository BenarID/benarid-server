defmodule AuthProvider.Router do
  use AuthProvider.Web, :router

  pipeline :auth_provider do
    plug :accepts, ["json"]
  end

  scope "/", AuthProvider do
    pipe_through :auth_provider

    get "/", IndexController, :index
  end
end
