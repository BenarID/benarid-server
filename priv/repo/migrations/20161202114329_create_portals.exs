defmodule BenarID.Repo.Migrations.CreatePortals do
  use Ecto.Migration

  def change do
    create table(:portals) do
      add :slug, :string
      add :name, :string
      add :site_url, :string

      timestamps()
    end

    create unique_index(:portals, [:slug])

    create table(:portal_hosts) do
      add :portal_id, references(:portals,
        on_delete: :delete_all,
        on_update: :update_all
      )
      add :hostname, :string

      timestamps()
    end

    create unique_index(:portal_hosts, [:hostname])
  end
end
