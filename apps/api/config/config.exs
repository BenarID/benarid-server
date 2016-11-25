use Mix.Config

config :api,
  namespace: API

# Configures the endpoint
config :api, API.Endpoint,
  http: [port: System.get_env("API_PORT") || "${API_PORT}"],
  secret_key_base: "yyJ3wSbnU9Z+t7zhD0o5L2mCXj7aJABNWkFQb3q4u1wYYZrByBbtO0GhJKIyfShZ",
  render_errors: [view: API.ErrorView, accepts: ~w(json)]

# Tell phoenix to serve all endpoints
config :phoenix, :serve_endpoints, true

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

import_config "#{Mix.env}.exs"
