defmodule SlackTemplate.Test.Plug.VerifyTokenPlugTest do
  use SlackTemplate.PlugCase

  test "it allows requests with valid token" do
    valid_token = Application.get_env(:slack_template, :slack_token)
    conn(:post, "/template", "token=#{valid_token}")
    |> pass_request
    |> assert_OK_response
  end

  test "it rejects requests without token" do
    assert_raise SlackTemplate.Plug.VerifyTokenPlug.MissingTokenError, fn ->
      conn(:post, "/template", "")
      |> pass_request
    end
  end

  test "it rejects requests with invalid token" do
    assert_raise SlackTemplate.Plug.VerifyTokenPlug.InvalidTokenError, fn -> 
      conn(:post, "/template", "token=invalidtoken123")
      |> pass_request
    end
  end
end
