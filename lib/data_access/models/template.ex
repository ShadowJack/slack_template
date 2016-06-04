defmodule SlackTemplate.Models.Template do
  require Logger
  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset
  alias SlackTemplate.Repo

  @moduledoc """
  Basic entity of the application
  """

  schema "templates" do
    field :team_id, :string
    field :user_id, :string
    field :name, :string
    field :text, :string

    timestamps
  end

  @required_fields ~w/team_id user_id name/
  @optional_fields ~w/text/

  def changeset(template, params \\ :empty) do
    template
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name, name: :templates_unique_constraint_index)
  end

  @doc """
  Add new template or update existing one
  Receives an ecto query and %Template{} map with data to be inserted/updated
  """
  @spec add_or_update(Ecto.Queryable, %{}) :: String.t
  def add_or_update(query, params) do
    query = from t in query,
            where: t.team_id == ^params[:team_id] and
                   t.user_id == ^params[:user_id] and
                   t.name == ^params[:name],
            select: t

    template =
      case Repo.one(query) do
        nil -> %__MODULE__{}
        template -> template
      end

    result = template
      |> __MODULE__.changeset(params)
      |> Repo.insert_or_update

    case result do
      {:ok, _template} -> "Done!"
      {:error, changes} ->
        Logger.error(inspect(changes.errors))
        "Error: #{inspect(changes.errors)}"
    end
  end

  @doc """
  Tries to get a text of the saved template.
  Receives an Ecto.Query to query upon
  and a %Template{} struct of params to search for.
  """
  @spec get(Ecto.Queryable, %{}) :: String.t
  def get(query, params) do
    query = from t in query,
            where: t.team_id == ^params[:team_id] and
                   t.user_id == ^params[:user_id] and
                   t.name == ^params[:name],
            select: t

    case Repo.one(query) do
      nil -> "Sorry, this template is not found"
      template -> template.text
    end
  end

  @doc """
  Returns a list of template names for specific user.
  Receives an Ecto.Query to query upon
  and a %Template{} struct of params to search for.
  """
  @spec list_all(Ecto.Queryable, %{}) :: [String.t]
  def list_all(query, params) do
    query = from t in query,
            where: t.team_id == ^params[:team_id] and
                   t.user_id == ^params[:user_id],
            order_by: [asc: t.name],
            select: t.name

    case Repo.all(query) do
      nil -> "You don't have any saved templates"
      list -> list
    end
  end
end
