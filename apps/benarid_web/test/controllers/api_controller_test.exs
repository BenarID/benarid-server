defmodule BenarIDWeb.APIControllerTest do
  use BenarIDWeb.ConnCase, async: true

  setup %{conn: conn} do
    # TODO: Insert portals
    Mix.Task.run "benarid.portal.sync", ["--all"]
    Mix.Task.run "benarid.rating.sync"

    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  ## /process endpoint
  test "/process: ", %{conn: conn} do
    conn = post conn, api_path(conn, :process), %{url: "http://google.com"}

    assert 1 + 1 == 2
  end

  ## /stats endpoint

  ## /rate endpoint

  ## /me endpoint

  ## Helper functions
end
