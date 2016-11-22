use Mix.Config

config :data, Data.Repo,
  pool: Ecto.Adapters.SQL.Sandbox
