defmodule TasktrackerWeb.IssueController do
  use TasktrackerWeb, :controller

  plug :authenticate

  alias Tasktracker.Tasks
  alias Tasktracker.Tasks.Issue
  alias Tasktracker.Accounts

  def index(conn, _params) do
    issues = Tasks.list_issues()
    users = Accounts.list_users()
    curr_user_id = if conn.assigns[:current_user], do: conn.assigns[:current_user].id, else: -1
    my_issues = issues
               |> Enum.filter(
                    fn issue -> curr_user_id == issue.user_id
                    end
                  )
    open_issues = issues
                 |> Enum.filter(fn issue -> !issue.completed end)
    closed_issues = issues
                   |> Enum.filter(fn issue -> issue.completed end)
    render(conn, "index.html", open_issues: open_issues,closed_issues: closed_issues,my_issues: my_issues, users: users)
  end

  def new(conn, _params) do
    changeset = Tasks.change_issue(%Issue{})
    render(conn, "new.html", users: Accounts.list_users, changeset: changeset)
  end

  def create(conn, %{"issue" => issue_params}) do
    case Tasks.create_issue(issue_params) do
      {:ok, issue} ->
        conn
        |> put_flash(:info, "Issue created successfully.")
        |> redirect(to: issue_path(conn, :show, issue))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, users: Accounts.list_users)
    end
  end

  def show(conn, %{"id" => id}) do
    issue = Tasks.get_issue!(id)
    user = Accounts.get_user(issue.user_id || -1)
    assigned_user = if user, do: user.name, else: "No user assigned"
    render(conn, "show.html", issue: issue, user_name: assigned_user)
  end

  def edit(conn, %{"id" => id}) do
    issue = Tasks.get_issue!(id)
    if issue.user_id != nil && (!conn.assigns[:current_user] || conn.assigns[:current_user].id != issue.user_id) do
      conn
      |> put_flash(:error, "Cannot update task belong to another user.")
      |> redirect(to: issue_path(conn, :index))
    else
      changeset = Tasks.change_issue(issue)
      render(conn, "edit.html", issue: issue, users: Accounts.list_users, changeset: changeset)
    end

  end

  def update(conn, %{"id" => id, "issue" => issue_params}) do
    issue = Tasks.get_issue!(id)

    if issue.user_id != nil && (!conn.assigns[:current_user] || conn.assigns[:current_user].id != issue.user_id) do
      conn
      |> put_flash(:error, "Cannot update task belong to another user.")
      |> redirect(to: issue_path(conn, :index))
    else
      case Tasks.update_issue(issue, issue_params) do
        {:ok, issue} ->
          conn
          |> put_flash(:info, "Issue updated successfully.")
          |> redirect(to: issue_path(conn, :show, issue))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", issue: issue, changeset: changeset, users: Accounts.list_users)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    issue = Tasks.get_issue!(id)
    {:ok, _issue} = Tasks.delete_issue(issue)

    conn
    |> put_flash(:info, "Issue deleted successfully.")
    |> redirect(to: issue_path(conn, :index))
  end

  defp authenticate(conn, _) do
    if conn.assigns[:current_user] == nil do
      conn |> put_flash(:info, "You must be logged in") |> redirect(to: page_path(conn, :index)) |> halt()
      else
      conn
    end
  end
end
