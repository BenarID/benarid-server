use Mix.Config

config :benarid, BenarID.Repo,
  database: "#{System.get_env("DB_NAME")}_test",
  pool: Ecto.Adapters.SQL.Sandbox
