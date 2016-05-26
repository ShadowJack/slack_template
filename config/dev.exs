use Mix.Config

config :logger, :console, format: "[$level] $message\n"

config :slack_template, SlackTemplate.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "shadowjack",
  password: "",
  database: "slack_template_dev",
  hostname: "localhost",
  pool_size: 10

config :slack_template, :cowboy_port, "8080"
