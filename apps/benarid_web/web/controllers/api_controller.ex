defmodule BenarIDWeb.APIController do
  use BenarIDWeb.Web, :controller

  alias BenarID.Member

  def me(conn, _params) do
    {:found, member} = Member.find_by_id(conn.assigns.user.id)
    json conn, %{id: member.id, name: member.name}
  end

end
