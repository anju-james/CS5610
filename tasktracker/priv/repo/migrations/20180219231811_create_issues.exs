defmodule Tasktracker.Repo.Migrations.CreateIssues do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :title, :string
      add :description, :string
      add :time_spent_mins, :integer
      add :completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:issues, [:title])
    create index(:issues, [:user_id])
  end
end
