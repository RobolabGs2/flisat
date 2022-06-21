import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :flisat, Flisat.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "flisat_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :flisat, FlisatWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "nHjTOxC4wAgctZWPRNKKbcCyexUNEhAfbLT1LWF2OJoL31Lro58DywNjmzaaYhVI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :flisat, Flisat.Accounts.Services.Guardian,
  secret_key: "jx5m5YtTHyUg6OSKWYOiFJlZsnboMzClmx+ZDXuZTlDDh9bxAEu1U/1y8oY+lnfU"
