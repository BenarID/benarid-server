defmodule BenarID.Web.APIControllerTest do
  use BenarID.Web.ConnCase, async: true

  alias BenarID.Schema.{
    Portal,
    PortalHost,
  }

  @portal %{name: "Detik.com", slug: "detikcom", site_url: "http://www.detik.com"}
  @portal_hosts %{hostname: "news.detik.com"}
  @article_url "https://news.detik.com/internasional/3377369/usai-penangkapan-teroris-di-tangsel-australia-imbau-warganya-waspada"

  setup %{conn: conn} do
    portal = Repo.insert! Portal.changeset(%Portal{}, @portal)
    _portal_host = Repo.insert! PortalHost.changeset(%PortalHost{}, Map.put(@portal_hosts, :portal_id, portal.id))
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  ## /process tests

  test "/process: non-existent portal url should return not found", %{conn: conn} do
    conn = post conn, api_path(conn, :process), %{url: "http://foobar.com/baz"}
    assert json_response(conn, 200)["not_found"] == true
  end

  test "/process: matching portal should create new article entry", %{conn: conn} do
    conn = post conn, api_path(conn, :process), %{url: @article_url}
    assert json_response(conn, 200)["id"] > 0
  end

  test "/process: existing article should return the same id", %{conn: conn} do
    conn1 = post conn, api_path(conn, :process), %{url: @article_url}
    article_id = json_response(conn1, 200)["id"]
    conn2 = post conn, api_path(conn, :process), %{url: @article_url}
    assert json_response(conn2, 200)["id"] == article_id
  end

  ## /stats tests

  test "/stats: should give stats of an article id", %{conn: conn} do
    conn1 = post conn, api_path(conn, :process), %{url: @article_url}
    article_id = json_response(conn1, 200)["id"]
    conn2 = get conn, api_path(conn, :stats), %{id: article_id}
    assert json_response(conn2, 200)["ok"] == true
  end

  ## /me tests

  ## /rate tests
end
