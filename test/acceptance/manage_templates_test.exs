defmodule SlackTemplate.Acceptance.ManageTemplatesTest do
  use SlackTemplate.ModelCase
  use Plug.Test

  alias SlackTemplate.{Plug.Router,Models.Template}

  @contentType "application/x-www-form-urlencoded"
  @teamId "T0001"
  @userId "U12345"
  @templateName "test_template"
  @templateText "Some awesome template text"

  test "it creates a new template and returns OK status" do

    content = build_request_content("set", @templateText)
    conn(:post, "/template", content)
    |> pass_request
    |> assert_OK_response

    query = from t in Template,
            where: t.name == @templateName,
            select: t
    template = Repo.one(query)
    assert template.text == @templateText
    assert template.user_id == @userId
    assert template.team_id == @teamId
  end

  test "it updates existing template with new text and returns OK status" do
    created = create_default_template

    new_text = "Some very different template text!!!"
    content = build_request_content("set", new_text)
    conn(:post, "/template", content)
    |> pass_request
    |> assert_OK_response

    query = from t in Template,
            where: t.name == @templateName,
            select: t
    template = Repo.one(query)
    assert template.id == created.id
    assert template.text == new_text
  end

  test "it reads existing template" do
    create_default_template

    content = build_request_content("get")
    conn = conn(:post, "/template", content)
    |> pass_request

    assert_OK_response(conn)
    assert conn.resp_body == @templateText
  end

  test "it lists all existing templates" do
    create_default_template

  end


  defp create_default_template() do
    {:ok, created} = Template.changeset(
      %Template{}, 
      %{
        team_id: @teamId,
        user_id: @userId, 
        name: @templateName, 
        text: @templateText
      }
    )
    |> Repo.insert
    
    created
  end

  defp build_request_content(command, text \\ "") do
    token = Application.get_env(:slack_template, :slack_token)
    "text=#{command} #{@templateName} #{text}&token=#{token}&team_id=#{@teamId}&team_domain=example&channel_id=C6789123&channel_name=test&user_id=#{@userId}&user_name=TestUser&command=/template"
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

end
