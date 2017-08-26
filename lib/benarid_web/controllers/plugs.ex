defmodule BenarIDWeb.Plugs do
  @moduledoc """
  Collections of plug related to BenarIDWeb.
  """

  import Plug.Conn

  alias BenarID.Auth
  alias BenarIDWeb.AuthController
  alias BenarIDWeb.TokenHelper

  @doc """
  Handle checking for blacklisted tokens.
  """
  def check_blacklisted_token(conn, _opts) do
    token = conn |> get_req_header("authorization") |> TokenHelper.fetch_token_from_headers
    blacklisted = Auth.blacklisted?(token)
    handle_blacklisted(conn, blacklisted)
  end

  defp handle_blacklisted(conn, false), do: conn
  defp handle_blacklisted(conn, true) do
    conn = conn |> halt
    AuthController.unauthenticated(conn, conn.params)
  end
end
