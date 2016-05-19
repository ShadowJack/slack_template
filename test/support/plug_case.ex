defmodule SlackTemplate.PlugCase do
  use ExUnit.CaseTemplate
  use Plug.Test
  alias SlackTemplate.Plug.Router

  @contentType "application/x-www-form-urlencoded"

  using do
    quote do
      use Plug.Test
      import SlackTemplate.PlugCase
    end
  end

  @doc """
  Helper function that puts content-type header and
  passes request to the router
  """
  def pass_request(conn) do
    conn
    |> put_req_header("content-type", @contentType)
    |> Router.call(Router.init([]))
  end

  @doc """
  Helper function that validates the successful status
  of the request
  """
  def assert_OK_response(conn) do
    assert conn.state == :sent
    assert conn.status == 200
  end

  @doc """
  Helper function that validates the error status
  """
  def assert_failed_response(conn) do
    assert conn.state == :sent
    assert conn.status >= 400
  end
end
