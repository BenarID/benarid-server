defmodule BenarID.Auth do
  @moduledoc false

  import Ecto.Query

  alias BenarID.Repo
  alias BenarID.Schema.TokenBlacklist

  def blacklist_token(nil, _), do: {:error, :invalid_token}
  def blacklist_token(token, expire_at) do
    changeset = TokenBlacklist.changeset(%TokenBlacklist{}, %{
      token: token,
      expire_at: expire_at,
    })

    case Repo.insert(changeset) do
      {:ok, _entry} ->
        :ok
      {:error, _} ->
        {:error, changeset.errors}
    end
  end

  def blacklisted?(nil), do: false
  def blacklisted?(token) do
    query = from t in TokenBlacklist, where: t.token == ^token

    case Repo.one(query) do
      nil ->
        false
      _ ->
        true
    end
  end

  def clear_expired_token_from_blacklist do
    timestamp = System.system_time(:seconds)
    query = from t in TokenBlacklist, where: t.expire_at <= ^timestamp

    {delete_count, _} = Repo.delete_all(query)
    {:ok, delete_count}
  end
end
