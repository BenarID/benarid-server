defmodule BenarIDWeb.AuthController do
  use BenarIDWeb.Web, :controller

  plug Ueberauth

  alias BenarID.Member

  @doc """
  Callback for failed authentication.
  """
  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    json conn, %{message: "Failed to authenticate."}
  end

  @doc """
  Callback for successful authentication.
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    member_data = user_from_auth(auth)

    member = case Member.find(email: member_data.email) do
      :not_found ->
        {:ok, member} = Member.register(member_data)
        member
      {:found, member} ->
        member
    end

    token = Phoenix.Token.sign(BenarIDWeb.Endpoint, "member", %{id: member.id})

    redirect conn, to: "/auth/retrieve#token=#{token}"
  end

  @doc """
  Route for passing token to client-side apps.
  """
  def retrieve(conn, _params) do
    html conn, """
      <!DOCTYPE html>
      <title>Harap tunggu sebentar...</title>
      <p>Harap tunggu sebentar...</p>
    """
  end

  @doc """
  Handler for failed authentication.
  """
  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{unauthenticated: true})
  end

  defp user_from_auth(auth) do
    %{
      name: extract_name(auth),
      email: extract_email(auth),
      avatar: extract_avatar(auth),
      provider: auth.provider,
    }
  end

  defp extract_name(auth) do
    auth.info.name
  end

  defp extract_email(auth) do
    auth.info.email
  end

  defp extract_avatar(auth) do
    auth.info.image
  end

end
