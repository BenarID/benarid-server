defmodule BenarID.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :portal_id, references(:portals)
      add :url, :string

      timestamps()
    end

    create unique_index(:articles, [:url])
  end

end
