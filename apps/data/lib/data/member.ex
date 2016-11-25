defmodule Data.Member do
  @moduledoc """
  Module for authentication.

  Caution: API still not stable.
  """
  import Ecto.Query

  alias Data.Repo
  alias Data.Schema.Member

  def find(opts) do
    email = Keyword.get(opts, :email)
    query = from m in Member, where: m.email == ^email

    case Repo.one(query) do
      nil ->
        :not_found
      member ->
        {:found, member}
    end
  end

  def register(data) do
    changeset = Member.changeset(%Member{}, data)

    case Repo.insert(changeset) do
      {:ok, member} ->
        {:ok, member}
      {:error, _} ->
        {:error, changeset.errors}
    end
  end
end
