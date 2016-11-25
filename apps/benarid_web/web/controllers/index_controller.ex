defmodule BenarIDWeb.IndexController do
  use BenarIDWeb.Web, :controller

  def index(conn, _params) do
    json conn, %{"hello" => "world"}
  end

end
