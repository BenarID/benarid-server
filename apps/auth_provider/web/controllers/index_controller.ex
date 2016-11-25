defmodule AuthProvider.IndexController do
  use AuthProvider.Web, :controller

  def index(conn, _params) do
    json conn, %{"hello" => "world"}
  end

end
