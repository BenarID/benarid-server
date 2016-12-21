# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :benarid,
  namespace: BenarID,
  ecto_repos: [BenarID.Repo]

# Configures the endpoint
config :benarid, BenarID.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "localhost"],
  secret_key_base: "p5f1dgYbrl2JzHic65vFjdT8k/4C2Z/Hoyy8eVmej3jruSFV0BonJZcbF11V+3RR",
  render_errors: [view: BenarID.Web.ErrorView, accepts: ~w(json)]

# Configure your database
config :benarid, BenarID.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOST")

# Configure Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
