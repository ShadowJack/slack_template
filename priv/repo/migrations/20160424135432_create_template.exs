defmodule SlackTemplate.Repo.Migrations.CreateTemplate do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :team_id, :string, null: false
      add :user_id, :string, null: false
      add :name, :string, null: false
      add :text, :string

      timestamps
    end

    create unique_index(:templates, [:team_id, :user_id, :name], name: :templates_unique_constraint_index)
  end
end
