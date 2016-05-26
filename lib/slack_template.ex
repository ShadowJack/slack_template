defmodule SlackTemplate do
  use Application
  import Logger

  def start(_type, _args) do
    import Supervisor.Spec

    port = String.to_integer(Application.get_env(:slack_template, :cowboy_port, "8080"))
    Logger.info("Port: #{port}")

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
