defmodule BenarID.Web.APIControllerTest do
  use BenarID.Web.ConnCase, async: true

  alias BenarID.Schema.{
    Portal,
    PortalHost,
    Member,
  }

  @portal %{name: "Detik.com", slug: "detikcom", site_url: "http://www.detik.com"}
  @portal_hosts %{hostname: "news.detik.com"}
  @article_url "https://news.detik.com/internasional/3377369/usai-penangkapan-teroris-di-tangsel-australia-imbau-warganya-waspada"
  @member %{name: "Kairi", email: "kairi@email.com"}

  setup %{conn: conn} do
    portal = Repo.insert! Portal.changeset(%Portal{}, @portal)
    _portal_host = Repo.insert! PortalHost.changeset(%PortalHost{}, Map.put(@portal_hosts, :portal_id, portal.id))
    member = Repo.insert! Member.changeset(%Member{}, @member)
    {:ok, conn: put_req_header(conn, "accept", "application/json"), data: %{member: member}}
  end

  ## /process tests

  test "/process: non-existent portal url should return not found", %{conn: conn} do
    conn = post conn, api_path(conn, :process), %{url: "http://foobar.com/baz"}
    assert json_response(conn, 200) == %{
      "id" => nil,
      "message" => "Portal berita tidak ditemukan di database.",
    }
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

  test "/process: should return rating of an existing article", %{conn: conn} do
    conn = post conn, api_path(conn, :process), %{url: @article_url}
    assert json_response(conn, 200)["rating"] == []
  end

  test "/process: should have `rated` field if member is authenticated", %{conn: conn, data: data} do
    conn = authenticate conn, data
    conn = post conn, api_path(conn, :process), %{url: @article_url}
    assert json_response(conn, 200)["rated"] == false
  end

  ## /me tests

  test "/me: should give name of authenticated member", %{conn: conn, data: data} do
    conn = authenticate conn, data
    conn = get conn, api_path(conn, :me)
    assert json_response(conn, 200) == %{
      "id" => data.member.id,
      "name" => data.member.name,
    }
  end

  ## /rate tests

  ## helper functions

  defp authenticate(conn, data) do
    conn |> assign(:user, %{id: data.member.id})
  end
end
