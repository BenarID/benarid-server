use Mix.Config

config :auth_provider,
  namespace: AuthProvider

# Configures the endpoint
config :auth_provider, AuthProvider.Endpoint,
  http: [port: System.get_env("AUTH_PROVIDER_PORT") || "${AUTH_PROVIDER_PORT}"],
  secret_key_base: "yyJ3wSbnU9Z+t7zhD0o5L2mCXj7aJABNWkFQb3q4u1wYYZrByBbtO0GhJKIyfShZ",
  render_errors: [view: AuthProvider.ErrorView, accepts: ~w(json)]

# Tell phoenix to serve all endpoints
config :phoenix, :serve_endpoints, true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
