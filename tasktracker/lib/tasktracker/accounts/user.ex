defmodule Tasktracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    #has_many :issues, Tasktracker.Tasks.Issue



    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, max: 255)
    |> validate_length(:email, max: 255)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/, message: "Not a valid email address")
  end
end
