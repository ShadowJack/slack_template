defmodule SlackTemplate.Business.TemplateManager do
  alias SlackTemplate.Models.Template

  @doc """
  Processes user request: 
  gets request parameters and returns response message
  """
  @spec process(%{String.t => String.t}) :: String.t
  def process(%{"user_id" => user_id, "team_id" => team_id, "text" => text}) do
    text
    |> String.split(" ")
    |> do_process(team_id, user_id)
  end

  def process(_) do 
    "Please enter some command\n\n" <> print_usage
  end



  @spec do_process([String.t], String.t, String.t) :: String.t
  defp do_process(["help"], _team_id, _user_id) do
    print_usage
  end

  @spec do_process([String.t], String.t, String.t) :: String.t
  defp do_process(["set", name | splitted_text], team_id, user_id) do
    text = Enum.join(splitted_text, " ")
    changes = %{
      team_id: team_id,
      user_id: user_id,
      name: name,
      text: text
    }

    Template.add_or_update(Template, changes)
  end

  @spec do_process([String.t], String.t, String.t) :: String.t
  defp do_process(["get", name | _args], team_id, user_id) do
    params = %{
      name: name,
      team_id: team_id,
      user_id: user_id
    }

    Template
    |> Template.get(params)
  end

  @spec do_process([String.t], String.t, String.t) :: String.t
  defp do_process(["list" | _], team_id, user_id) do
    params = %{
      team_id: team_id,
      user_id: user_id
    }

    Template
    |> Template.list_all(params)
    |> Enum.join("\n")
  end

  defp do_process(_, _, _) do
    "Oops, unknown command!\n\n" <> print_usage
  end

  defp print_usage do
    """
    Available commands:
    /template help - prints usage instructions
    /template set TEMPLATE_NAME TEMPLATE_TEXT - create a new template or update existing one
    /template get TEMPLATE_NAME - fetch saved template
    /template list - prints a list of all saved templates
    """
  end
end
