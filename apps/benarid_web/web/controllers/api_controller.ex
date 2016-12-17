defmodule BenarIDWeb.APIController do
  use BenarIDWeb.Web, :controller

  alias BenarID.{
    Member,
    Article,
  }

  def me(conn, _params) do
    {:found, member} = Member.find_by_id(conn.assigns.user.id)
    json conn, %{id: member.id, name: member.name}
  end

  def process(conn, %{"url" => url}) do
    case Article.process(url) do
      {:error, :not_found} ->
        json conn, %{not_found: true}
      {:ok, id} ->
        json conn, %{id: id}
    end
  end

  def stats(conn, %{"id" => id}) do
    json conn, %{id: id}
  end

  def rate(conn, %{"article_id" => article_id, "ratings" => ratings}) do
    member_id = conn.assigns.user.id
    ratings = ratings |> Enum.into([])
    case Article.rate(ratings, member_id, article_id) do
      :ok ->
        json conn, %{ok: true}
      _ ->
        json conn, %{ok: false}
    end
  end

end
