defmodule SlackTemplate.Plug.TemplatePlug do
  import Plug.Conn
  
  def init(opts), do: opts

  #TODO: create a plug that checks token
  def call(conn, _opts) do
    message = SlackTemplate.Business.TemplateManager.process(conn.params)
    send_resp(conn, 200, message)
  end
end
