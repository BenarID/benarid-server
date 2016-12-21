defmodule BenarID.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :name, :string
      add :email, :string

      timestamps()
    end

    create unique_index(:members, [:email])
  end
end
