defmodule SlackTemplate.Test.Acceptance.ManageTemplatesTest do
  use SlackTemplate.ModelCase
  use SlackTemplate.PlugCase

  alias SlackTemplate.Models.Template

  @teamId "T0001"
  @userId "U12345"
  @templateName "test_template"
  @templateText "Some awesome template text"

  test "it creates a new template and returns OK status" do

    content = build_request_content("set", @templateName, @templateText)
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
    content = build_request_content("set", @templateName, new_text)
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

    content = build_request_content("get", @templateName)
    conn = conn(:post, "/template", content)
    |> pass_request

    assert_OK_response(conn)
    assert conn.resp_body == @templateText
  end

  test "it lists all existing templates" do
    create_default_template
    create_default_template("a_template", "some text")

    content = build_request_content("list")
    conn = conn(:post, "/template", content)
    |> pass_request

    assert_OK_response(conn)
    assert conn.resp_body == "a_template\n#{@templateName}"
  end




  defp create_default_template(name \\ @templateName, text \\ @templateText) do
    {:ok, created} = Template.changeset(
      %Template{}, 
      %{
        team_id: @teamId,
        user_id: @userId, 
        name: name, 
        text: text 
      }
    )
    |> Repo.insert
    
    created
  end

  defp build_request_content(command, templateName \\ "", text \\ "") do
    token = Application.get_env(:slack_template, :slack_token)
    "text=#{command} #{templateName} #{text}&token=#{token}&team_id=#{@teamId}&team_domain=example&channel_id=C6789123&channel_name=test&user_id=#{@userId}&user_name=TestUser&command=/template"
  end


end
