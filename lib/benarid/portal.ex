defmodule BenarID.Portal do
  @moduledoc false

  import Ecto.Query

  alias Ecto.Multi
  alias BenarID.Repo
  alias BenarID.Schema.{
    Portal,
    PortalHost,
  }

  def create_portal(data) do
    changeset = Portal.changeset(%Portal{}, data)
    on_conflict = [set: [name: data.name, site_url: data.site_url]]

    case Repo.insert(changeset, on_conflict: on_conflict, conflict_target: :slug) do
      {:ok, portal} ->
        {:ok, portal}
      {:error, _} ->
        {:error, changeset.errors}
    end
  end

  def populate_hosts(portal, hosts) do
    multi =
      Multi.new
      |> Multi.delete_all(Ecto.UUID.generate(), Ecto.assoc(portal, :hosts))
    multi =
      hosts
      |> Enum.map(fn host -> %{hostname: host, portal_id: portal.id} end)
      |> Enum.map(fn host -> PortalHost.changeset(%PortalHost{}, host) end)
      |> Enum.reduce(multi, fn changeset, m ->
        Multi.insert(m, Ecto.UUID.generate(), changeset)
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

  def clear() do
    Repo.delete_all(Portal)
  end

end
