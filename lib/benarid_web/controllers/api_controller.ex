defmodule BenarIDWeb.APIController do
  use BenarIDWeb, :controller

  alias BenarID.{
    Auth,
    Article,
    Member,
    Rating,
    Portal,
  }
  alias BenarIDWeb.TokenHelper

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

  def logout(conn, _params) do
    token = conn |> get_req_header("authorization") |> TokenHelper.fetch_token_from_headers
    case Auth.blacklist_token(token) do
      :ok ->
        conn |> json(%{ok: true})
      {:error, _changeset} ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Gagal melakukan logout. Coba beberapa saat lagi."})
    end
  end

end
