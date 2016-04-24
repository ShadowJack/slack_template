defmodule SlackTemplate.Plug.TemplatePlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.puts(conn.params["text"])
    send_resp(conn, 200, "OK, got it")
  end
end
