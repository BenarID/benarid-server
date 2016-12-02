defmodule BenarID.Repo.Migrations.CreatePortals do
  use Ecto.Migration

  def change do
    create table(:portals) do
      add :slug, :string
      add :name, :string
      add :site_url, :string

      timestamps()
    end

    create table(:portal_hosts) do
      add :portal_id, references(:portals)
      add :hostname, :string
      
      timestamps()
    end
  end
end
