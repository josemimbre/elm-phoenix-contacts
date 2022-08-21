import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :contacts, ContactsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :contacts, Contacts.Repo,
  username: "root",
  password: "my-secret-pw",
  database: "contacts_dev",
  hostname: "database",
  pool: Ecto.Adapters.SQL.Sandbox
