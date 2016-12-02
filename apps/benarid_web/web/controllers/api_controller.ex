defmodule BenarIDWeb.APIController do
  use BenarIDWeb.Web, :controller

  alias BenarID.Member

  def me(conn, _params) do
    {:found, member} = Member.find_by_id(conn.assigns.user.id)
    json conn, %{id: member.id, name: member.name}
  end

  def process(conn, %{"url" => url}) do
    json conn, %{url: url}
  end

  def stats(conn, %{"id" => id}) do
    json conn, %{id: id}
  end

  def rate(conn, %{"id" => id}) do
    json conn, %{id: id}
  end

end
