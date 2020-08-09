# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :contacts,
  ecto_repos: [Contacts.Repo]

# Configures the endpoint
config :contacts, ContactsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WcMpq2gL0c9r1UJhZ4eg2pEgWJXz/k/YryZnPTZ4uhpHm/sqUo6HRWVDJl3nJKXh",
  render_errors: [view: ContactsWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Contacts.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
