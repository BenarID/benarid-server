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

    token = Phoenix.Token.sign(BenarIDWeb.Endpoint, "member", member.id)

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

  defp user_from_auth(auth) do
    %{
      name: extract_name(auth),
      email: extract_email(auth),
      avatar: extract_avatar(auth),
      provider: auth.provider,
    }
  end

  defp extract_name(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

  defp extract_email(auth) do
    auth.info.email
  end

  defp extract_avatar(auth) do
    auth.info.image
  end

end
