defmodule SlackTemplate.Plug.TemplatePlug do
  import Plug.Conn

  @moduledoc """
  A plug that passes requests to TemplateManager service.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    message = SlackTemplate.Business.TemplateManager.process(conn.params)
    send_resp(conn, 200, message)
  end
end
