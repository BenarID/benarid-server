defmodule BenarID.Web.APIController do
  use BenarID.Web, :controller

  def me(conn, _params) do
    {:found, member} = BenarID.find_member_by_id(conn.assigns.user.id)
    conn |> json(%{id: member.id, name: member.name})
  end

  def process(conn, %{"url" => url}) do
    member_id = if conn.assigns[:user] do
      conn.assigns.user.id
    end
    case BenarID.process_url(url, member_id) do
      {:ok, article_stats} ->
        conn |> json(article_stats)
      {:error, :not_found} ->
        conn |> put_status(:unprocessable_entity) |> json(%{message: "Portal berita tidak ditemukan di database."})
    end
  end

  def rate(conn, %{"article_id" => article_id, "ratings" => ratings}) do
    member_id = conn.assigns.user.id
    ratings = ratings |> Enum.into([])
    case BenarID.rate_article(ratings, member_id, article_id) do
      :ok ->
        conn |> json(%{ok: true})
      :error ->
        conn |> put_status(404) |> json(%{message: "not found"})
    end
  end

end
