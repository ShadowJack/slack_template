defmodule SlackTemplate.Plug.VerifyTokenPlug do
  import Plug.Conn
  
  def init(opts), do: opts

  def call(%Plug.Conn{params: params} = conn, _opts) do
    valid_token = Application.get_env(:slack_template, :slack_token) 
    case params[:token] do
      valid_token -> conn
      nil -> send_resp(conn, 500, "Token is missing")
      _ -> send_resp(conn, 500, "Invalid token")
    end
  end
end
