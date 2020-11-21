# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jet,
  ecto_repos: [Jet.Repo]

# Configures the endpoint
config :jet, JetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tutyH7RPAuwXaFer0Hlx6Duk7HJymq/I943Z9795XxzLbDZRxBAhM0JvUi18CRqN",
  render_errors: [view: JetWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Jet.PubSub,
  live_view: [signing_salt: "mb5p6EH+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
