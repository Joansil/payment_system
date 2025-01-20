# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :payment_system,
  ecto_repos: [PaymentSystem.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :payment_system, PaymentSystemWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: PaymentSystemWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PaymentSystem.PubSub,
  live_view: [signing_salt: "6HypAMxV"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :payment_system, PaymentSystem.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config
# Run this to generate your secret_key: :crypto.strong_rand_bytes(64) |> Base.encode64() |> binary_part(0, 64)
# More here - https://hexdocs.pm/guardian/Guardian.html#module-configuration
config :payment_system, PaymentSystemWeb.Auth.Guardian,
  issuer: "payment_system",
  secret_key: "IYMJ2xXdsPYj6nBB10+nsk9/bNfeRllrNJOwIy7GGrUd729vBSciJfZjo7GXPhdw"


# Guardian config
# Run this to generate your secret_key: :crypto.strong_rand_bytes(64) |> Base.encode64() |> binary_part(0, 64)
# More here - https://hexdocs.pm/guardian/Guardian.html#module-configuration
config :payment_system, PaymentSystemWeb.Auth.Guardian,
  issuer: "payment_system",
  secret_key: "IYMJ2xXdsPYj6nBB10+nsk9/bNfeRllrNJOwIy7GGrUd729vBSciJfZjo7GXPhdw"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
