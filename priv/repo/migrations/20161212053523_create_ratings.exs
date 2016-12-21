defmodule BenarID.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :slug, :string
      add :label, :string

      timestamps()
    end

    create unique_index(:ratings, [:slug])

    create table(:article_ratings) do
      add :article_id, references(:articles)
      add :rating_id, references(:ratings)
      add :member_id, references(:members)
      add :value, :integer

      timestamps()
    end

    create unique_index(:article_ratings, [:article_id, :rating_id, :member_id])
  end
end
