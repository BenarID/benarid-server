defmodule BenarID.Repo.Migrations.CreateTokenBlacklist do
  use Ecto.Migration

  def change do
    create table(:token_blacklist, primary_key: false) do
      add :token, :string, primary_key: true
      add :expire_at, :integer, null: false
    end
    create index(:token_blacklist, [:expire_at])
  end
end
