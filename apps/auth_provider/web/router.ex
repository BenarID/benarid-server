defmodule AuthProvider.Router do
  use AuthProvider.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/auth", AuthProvider do
    pipe_through :browser

    get "/retrieve", AuthController, :retrieve
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
