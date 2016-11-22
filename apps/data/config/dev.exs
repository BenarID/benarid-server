use Mix.Config

config :logger, :console, format: "[$level] $message\n"

config :data, Data.Repo,
  pool_size: 10
