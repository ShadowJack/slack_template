ExUnit.start()

Mix.Task.run "ecto.create", ~w(-r SlackTemplate.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r SlackTemplate.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(SlackTemplate.Repo, :manual)

