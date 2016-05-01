defmodule SlackTemplate.Plug.Router do
  use Plug.Router

  alias SlackTemplate.Plug.TemplatePlug

  plug Plug.Parsers, parsers: [:urlencoded]
  #TODO: fix connection
  plug SlackTemplate.Plug.VerifyTokenPlug

  plug :match
  plug :dispatch

  post "/template", do: TemplatePlug.call(conn, [])
  match _, do: send_resp(conn, 404, "Sorry")

end
