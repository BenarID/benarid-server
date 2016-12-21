defmodule BenarID.Web.IndexController do
  use BenarID.Web, :controller

  def index(conn, _params) do
    json conn, %{"hello" => "world"}
  end

end
