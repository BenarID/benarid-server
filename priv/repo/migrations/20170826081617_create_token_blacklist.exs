defmodule BenarID.Repo.Migrations.CreateTokenBlacklist do
  use Ecto.Migration

  def change do
    create table(:token_blacklist, primary_key: false) do
      add :token, :string, primary_key: true
    end
  end
end
