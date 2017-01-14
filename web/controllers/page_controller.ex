defmodule BenarID.Web.PageController do
  use BenarID.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
