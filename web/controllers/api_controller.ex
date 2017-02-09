defmodule BenarID.Web.APIController do
  use BenarID.Web, :controller

  alias BenarID.{
    Article,
    Member,
    Rating,
    Portal,
  }

  def me(conn, _params) do
    {:found, member} = Member.find_by_id(conn.assigns.user.id)
    conn |> json(%{id: member.id, name: member.name})
  end

  def process(conn, %{"url" => url}) do
    member_id = if conn.assigns[:user] do
      conn.assigns.user.id
    end
    case Article.process_url(url, member_id) do
      {:ok, article_stats} ->
        conn |> json(article_stats)
      {:error, :not_found} ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Portal berita tidak ditemukan di database."})
      {:error, :invalid_url} ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "URL bukan artikel berita."})
    end
  end

  def rate(conn, %{"article_id" => article_id, "ratings" => ratings}) do
    member_id = conn.assigns.user.id
    ratings = ratings |> Enum.into([])
    case Rating.rate_article(ratings, member_id, article_id) do
      :ok ->
        conn |> json(%{ok: true})
      {:error, :not_found} ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Artikel tidak ditemukan di database."})
      {:error, :has_rated} ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Anda sudah memberikan rating untuk artikel ini."})
      {:error, :invalid_value} ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Rating yang diberikan invalid."})
    end
  end

  def portals(conn, _params) do
    portals = Portal.find_all
    conn |> json(portals)
  end

end
