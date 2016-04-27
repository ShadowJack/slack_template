defmodule SlackTemplate.Business.TemplateManager do
  require Logger
  import Ecto.Query, only: [from: 2]
  alias SlackTemplate.{Repo, Models.Template}

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

  def process(_), do: "Bad request: one of parameters is missing"



  @spec do_process([String.t], String.t, String.t) :: String.t
  defp do_process(["help"], _team_id, _user_id) do
    """
    Available commands:
    /template help - prints usage instructions
    /template set TEMPLATE_NAME TEMPLATE_TEXT - create a new template or update existing one
    /template get TEMPLATE_NAME - fetch saved template
    """
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

    query = from t in Template,
            where: t.team_id == ^team_id and
                   t.user_id == ^user_id and 
                   t.name == ^name,
            select: t

    result = 
      case Repo.one(query) do
        nil -> %Template{}
        template -> template
      end
      |> Template.changeset(changes)
      |> Repo.insert_or_update

    case result do
      {:ok, template} -> "Done!"
      {:error, changeset} -> 
        Logger.error(inspect(changeset.errors))
        "Error: #{inspect(changeset.errors)}"
    end
  end

  #TODO: create a method for reading a template
  @spec do_process([String.t], String.t, String.t) :: String.t
  defp do_process(_, _, _) do """
    Ooops, I don\'t know this command.
    To get the list of available commands please enter:
    /template help
    """
  end


end
