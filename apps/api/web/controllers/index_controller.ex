defmodule API.IndexController do
  use API.Web, :controller

  def index(conn, _params) do
    json conn, %{"hello" => "world"}
  end

end
