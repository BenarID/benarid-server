use Mix.Config

config :logger, :console, format: "[$level] $message\n"

config :benarid, BenarID.Repo,
  pool_size: 10
