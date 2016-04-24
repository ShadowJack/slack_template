defmodule SlackTemplate.Models.Template do
  use Ecto.Schema
  import Ecto.Changeset

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
end
