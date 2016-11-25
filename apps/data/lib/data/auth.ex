defmodule Data.Auth do
  @moduledoc """
  Module for authentication.

  Caution: API still not stable.
  """
  import Ecto.Query

  alias Data.Repo
  alias Data.Schema.Member

  def get_member_by(:email, email) do
    query = from m in Member, where: m.email == ^email
    query_member(query)
  end
  def get_member_by(:name, name) do
    query = from m in Member, where: m.name == ^name
    query_member(query)
  end
  def get_member_by(:id, id) do
    query = from m in Member, where: m.id == ^id
    query_member(query)
  end

  defp query_member(query) do
    case Repo.one(query) do
      nil ->
        :not_found
      member ->
        {:found, member}
    end
  end

  def register_member(data) do
    changeset = Member.changeset(%Member{}, data)

    case Repo.insert(changeset) do
      {:ok, member} ->
        {:ok, member}
      {:error, _} ->
        {:error, changeset.errors}
    end
  end
end
