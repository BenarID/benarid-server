use Mix.Config

config :data, :console,
  format: "$time $metadata[$level] $message\n"

config :data,
  ecto_repos: [Data.Repo]

config :data, Data.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USERNAME") || "${DB_USERNAME}",
  password: System.get_env("DB_PASSWORD") || "${DB_PASSWORD}",
  database: System.get_env("DB_NAME") || "${DB_NAME}",
  hostname: System.get_env("DB_HOST") || "${DB_HOST}"

import_config "#{Mix.env}.exs"
