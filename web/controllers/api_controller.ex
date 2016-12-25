defmodule BenarID.Web.APIController do
  use BenarID.Web, :controller

  alias BenarID.{
    Member,
    Article,
  }

  def me(conn, _params) do
    {:found, member} = Member.find_by_id(conn.assigns.user.id)
    conn |> json(%{id: member.id, name: member.name})
  end

  def process(conn, %{"url" => url}) do
    case Article.process(url) do
      {:ok, id} ->
        conn |> json(%{id: id})
      {:error, :not_found} ->
        conn |> json(%{id: nil, message: "Portal berita tidak ditemukan di database."})
    end
  end

  def stats(conn, %{"id" => id}) do
    member_id = if conn.assigns[:user] do
      conn.assigns.user.id
    end
    case Article.stats(id, member_id) do
      {:ok, article_stats} ->
        conn |> json(article_stats)
      :error ->
        conn |> put_status(404) |> json(%{message: "not found"})
    end
  end

  def rate(conn, %{"article_id" => article_id, "ratings" => ratings}) do
    member_id = conn.assigns.user.id
    ratings = ratings |> Enum.into([])
    case Article.rate(ratings, member_id, article_id) do
      :ok ->
        conn |> json(%{ok: true})
      :error ->
        conn |> put_status(404) |> json(%{message: "not found"})
    end
  end

end
