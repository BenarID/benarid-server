defmodule BenarID.Portal do
  @moduledoc """
  Interface for managing portals.
  """

  import Ecto.Query

  alias Ecto.Multi
  alias BenarID.Repo
  alias BenarID.Schema.{
    Portal,
    PortalHost,
  }

  def create_portal(data) do
    changeset = Portal.changeset(%Portal{}, data)

    case Repo.insert(changeset) do
      {:ok, portal} ->
        {:ok, portal}
      {:error, _} ->
        {:error, changeset.errors}
    end
  end

  def populate_hosts(portal, hosts) do
    multi =
      hosts
      |> Enum.map(fn host -> %{hostname: host, portal_id: portal.id} end)
      |> Enum.map(fn host -> PortalHost.changeset(%PortalHost{}, host) end)
      |> Enum.reduce(Multi.new, fn changeset, multi ->
        Multi.insert(multi, Ecto.UUID.generate(), changeset)
      end)

    case Repo.transaction(multi) do
      {:ok, _} ->
        :ok
      error ->
        error
    end
  end

  def find_by_host(host) do
    query = from p in Portal,
      left_join: h in PortalHost, on: h.portal_id == p.id,
      where: h.hostname == ^host

    case Repo.one(query) do
      nil ->
        :not_found
      portal ->
        {:found, portal}
    end
  end

end
