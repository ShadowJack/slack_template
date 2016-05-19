defmodule SlackTemplate.Plug.VerifyTokenPlug do
  defmodule MissingTokenError do
    @moduledoc """
    Error raised when no slack token is provided in the request
    """

    defexception plug_status: 401, message: "Token is missing" 
  end

  defmodule InvalidTokenError do
    @moduledoc """
    Error raised when incalid slack token is provided in the request
    """

    defexception plug_status: 401, message: "Invalid token"
  end
  
  def init(opts), do: opts

  def call(%Plug.Conn{params: params} = conn, _opts) do
    valid_token = Application.get_env(:slack_template, :slack_token) 
    case params["token"] do
      ^valid_token -> conn
      nil -> raise MissingTokenError
      _ -> raise InvalidTokenError
    end
  end
end
