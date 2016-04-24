defmodule SlackTemplate do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    port = Application.get_env(:slack_template, :cowboy_port, 8080)

    children = [
      Plug.Adapters.Cowboy.child_spec(
        :http, 
        SlackTemplate.Plug.Router, 
        [], 
        port: port),
      supervisor(SlackTemplate.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: SlackTemplate.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
