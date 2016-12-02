use Mix.Config

config :benarid_web, BenarIDWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE") || "${SECRET_KEY_BASE}"

# Do not print debug messages in production
config :logger, level: :info