use Mix.Config

config :logger, level: :warn

config :slack_template, SlackTemplate.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "shadowjack",
  password: "",
  database: "slack_template_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :slack_template, slack_token: "test_token"
