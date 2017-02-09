defmodule BenarID.Web.APIControllerTest do
  use BenarID.Web.ConnCase, async: true

  alias BenarID.Schema.{
    Article,
    Portal,
    PortalHost,
    Member,
    Rating,
  }

  @portal %{name: "Detik.com", slug: "detikcom", site_url: "http://www.detik.com"}
  @portal_hosts %{hostname: "news.detik.com"}
  @article_url "https://news.detik.com/internasional/3377369/usai-penangkapan-teroris-di-tangsel-australia-imbau-warganya-waspada"
  @member %{name: "Kairi", email: "kairi@email.com"}
  @ratings [
    %{slug: "rating-1", label: "Rating 1", question: "Rating 1?"},
    %{slug: "rating-2", label: "Rating 2", question: "Rating 2?"},
  ]

  setup %{conn: conn} do
    portal = Repo.insert! Portal.changeset(%Portal{}, @portal)
    _portal_host = Repo.insert! PortalHost.changeset(%PortalHost{}, Map.put(@portal_hosts, :portal_id, portal.id))
    member = Repo.insert! Member.changeset(%Member{}, @member)
    data = %{portal: portal, member: member}
    {:ok, conn: put_req_header(conn, "accept", "application/json"), data: data}
  end

  ## /process tests

  test "/process: non-existent portal url should return not found", %{conn: conn} do
    conn = post conn, api_path(conn, :process), %{url: "http://foobar.com/baz"}
    assert json_response(conn, 422) == %{
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

  test "/process: should list all available ratings", %{conn: conn} do
    Enum.each @ratings, fn rating ->
      Repo.insert! Rating.changeset(%Rating{}, rating)
    end
    conn = post conn, api_path(conn, :process), %{url: @article_url}
    rating_response = json_response(conn, 200)["rating"]
    assert length(rating_response) == length(@ratings)
  end

  test "/process: a rating item should contain id, slug, label, value, and count", %{conn: conn} do
    rating = Enum.at(@ratings, 0)
    %{id: rating_id} = Repo.insert! Rating.changeset(%Rating{}, rating)
    conn = post conn, api_path(conn, :process), %{url: @article_url}
    rating_response = List.first(json_response(conn, 200)["rating"])
    assert rating_response == %{
      "id" => rating_id,
      "slug" => rating.slug,
      "label" => rating.label,
      "question" => rating.question,
      "sum" => 0,
      "count" => 0,
    }
  end

  test "/process: should have `rated` field if member is authenticated", %{conn: conn, data: data} do
    conn = authenticate conn, data
    conn = post conn, api_path(conn, :process), %{url: @article_url}
    assert json_response(conn, 200)["rated"] == false
  end

  ## /portals tests

  test "/portals: should return registered portals", %{conn: conn} do
    # Our APIs return JSON with string keys
    portal_with_string_keys =
      for {key, val} <- @portal, into: %{}, do: {Atom.to_string(key), val}
    conn = get conn, api_path(conn, :portals)
    assert json_response(conn, 200) == [portal_with_string_keys]
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

  test "/rate: should return ok: true if successfully rated", %{conn: conn, data: data} do
    ratings = Enum.map @ratings, fn rating ->
      %{id: rating_id} = Repo.insert! Rating.changeset(%Rating{}, rating)
      {"#{rating_id}", 1}
    end
    ratings_map = ratings |> Enum.into(%{})
    article =
      %Article{}
      |> Article.changeset(%{url: @article_url, portal_id: data.portal.id})
      |> Repo.insert!

    conn = authenticate conn, data
    conn = post conn, api_path(conn, :rate), %{
      article_id: article.id,
      ratings: ratings_map,
    }
    assert json_response(conn, 200) == %{
      "ok" => true
    }
  end

  test "/rate: nonexistent id should return not found", %{conn: conn, data: data} do
    ratings = Enum.map @ratings, fn rating ->
      %{id: rating_id} = Repo.insert! Rating.changeset(%Rating{}, rating)
      {"#{rating_id}", 1}
    end
    ratings_map = ratings |> Enum.into(%{})

    conn = authenticate conn, data
    conn = post conn, api_path(conn, :rate), %{
      article_id: 1000,
      ratings: ratings_map,
    }
    assert json_response(conn, 422) == %{
      "message" => "Artikel tidak ditemukan di database.",
    }
  end

  test "/rate: should handle invalid rating", %{conn: conn, data: data} do
    ratings = Enum.map @ratings, fn rating ->
      %{id: rating_id} = Repo.insert! Rating.changeset(%Rating{}, rating)
      {"#{rating_id}", 1000}
    end
    ratings_map = ratings |> Enum.into(%{})
    article =
      %Article{}
      |> Article.changeset(%{url: @article_url, portal_id: data.portal.id})
      |> Repo.insert!

    conn = authenticate conn, data
    conn = post conn, api_path(conn, :rate), %{
      article_id: article.id,
      ratings: ratings_map,
    }
    assert json_response(conn, 422) == %{
      "message" => "Rating yang diberikan invalid."
    }
  end

  test "/rate: should handle double rate", %{conn: conn, data: data} do
    ratings = Enum.map @ratings, fn rating ->
      %{id: rating_id} = Repo.insert! Rating.changeset(%Rating{}, rating)
      {"#{rating_id}", 1}
    end
    ratings_map = ratings |> Enum.into(%{})
    article =
      %Article{}
      |> Article.changeset(%{url: @article_url, portal_id: data.portal.id})
      |> Repo.insert!

    post_data = %{
      article_id: article.id,
      ratings: ratings_map,
    }

    conn = authenticate conn, data
    conn1 = post conn, api_path(conn, :rate), post_data
    assert json_response(conn1, 200) == %{
      "ok" => true,
    }

    conn2 = post conn, api_path(conn, :rate), post_data
    assert json_response(conn2, 422) == %{
      "message" => "Anda sudah memberikan rating untuk artikel ini."
    }
  end

  ## helper functions

  defp authenticate(conn, data) do
    conn |> assign(:user, %{id: data.member.id})
  end
end
