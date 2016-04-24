defmodule SlackTemplate.Acceptance.ManageTemplatesTest do
  use SlackTemplate.ModelCase
  use Plug.Test

  alias SlackTemplate.{Plug.Router,Models.Template}

  @contentType "application/x-www-form-urlencoded"
  @teamId "T0001"
  @userId "U12345"
  @templateName "test_template"

  test "it creates a new template and returns OK status" do
    text = "Some awesome template text"
    content = build_content("set", text)
    
    conn = conn(:post, "/template", content)
    |> pass_request
    |> assert_OK_response

    query = from t in Template,
            where: t.name == @templateName,
            select: t.text
    assert Repo.one(query) == text
  end

  test "it updates existing template with new text and returns OK status" do
    init_text = "First text"
    changeset = Template.changeset(%Template{}, %{team_id: @teamId, user_id: @userId, name: @templateName, text: init_text})
    {:ok, created} = Repo.insert(changeset)

    new_text = "Some very different template text!!!"
    content = build_content("set", new_text)
    conn = conn(:post, "/template", content)
    |> pass_request
    |> assert_OK_response

    query = from t in Template,
            where: t.name == @templateName,
            select: t
    template = Repo.one(query)
    assert template.id == created.id
    assert template.text == new_text
  end

  defp assert_OK_response(conn) do
    assert conn.state == :sent
    assert conn.status == 200
  end

  defp pass_request(conn) do
    conn
    |> put_req_header("content-type", @contentType)
    |> Router.call(Router.init([]))
  end

  defp build_content(command, text \\ "") do
    token = Application.get_env(:slack_template, :slack_token)
    "text=#{command} #{@templateName} #{text}&token=#{token}&team_id=#{@teamId}&team_domain=example&channel_id=C6789123&channel_name=test&user_id=#{@userId}&user_name=TestUser&command=/template"
  end
end
