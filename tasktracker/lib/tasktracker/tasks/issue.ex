defmodule Tasktracker.Tasks.Issue do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Tasks.Issue


  schema "issues" do
    field :completed, :boolean, default: false
    field :description, :string
    field :time_spent_mins, :integer
    field :title, :string
    field :user_id, :integer

    #belongs_to :user, Tasktracker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Issue{} = issue, attrs) do
    issue
    |> cast(attrs, [:title, :description, :time_spent_mins, :completed, :user_id])
    |> validate_required([:title, :description])
    |> validate_length(:title, max: 255)
    |> validate_length(:description, max: 255)
    |> unique_constraint(:title)
    |> validate_time_increment(:time_spent_mins)
    |> validate_issue_complete()
  end


  defp validate_time_increment(changeset, field, options \\ []) do
    validate_change(
      changeset,
      field,
      fn _, time_in_mins ->
        if time_in_mins > 0 && rem(time_in_mins, 15) != 0 do
          [{field, options[:message] || "Time should be an increment of 15"}]
        else
          []
        end
      end
    )
  end


  defp validate_issue_complete(changeset) do
    case changeset.valid? do
      true ->
        time_input = get_field(changeset, :time_spent_mins, 0)
        cond do
          time_input != nil && time_input > 0 && get_field(changeset, :completed, false) ->
            changeset
          get_field(changeset, :completed, false) == false ->
            changeset
          true ->
            add_error(changeset, :time_spent_mins, "Time Spent is missing for completed task.")
        end
      _ ->
        changeset
    end
  end
end
