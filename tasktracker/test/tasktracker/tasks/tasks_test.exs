defmodule Tasktracker.TasksTest do
  use Tasktracker.DataCase

  alias Tasktracker.Tasks

  describe "issues" do
    alias Tasktracker.Tasks.Issue

    @valid_attrs %{completed: true, description: "some description", time_spent_mins: 42, title: "some title"}
    @update_attrs %{completed: false, description: "some updated description", time_spent_mins: 43, title: "some updated title"}
    @invalid_attrs %{completed: nil, description: nil, time_spent_mins: nil, title: nil}

    def issue_fixture(attrs \\ %{}) do
      {:ok, issue} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_issue()

      issue
    end

    test "list_issues/0 returns all issues" do
      issue = issue_fixture()
      assert Tasks.list_issues() == [issue]
    end

    test "get_issue!/1 returns the issue with given id" do
      issue = issue_fixture()
      assert Tasks.get_issue!(issue.id) == issue
    end

    test "create_issue/1 with valid data creates a issue" do
      assert {:ok, %Issue{} = issue} = Tasks.create_issue(@valid_attrs)
      assert issue.completed == true
      assert issue.description == "some description"
      assert issue.time_spent_mins == 42
      assert issue.title == "some title"
    end

    test "create_issue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_issue(@invalid_attrs)
    end

    test "update_issue/2 with valid data updates the issue" do
      issue = issue_fixture()
      assert {:ok, issue} = Tasks.update_issue(issue, @update_attrs)
      assert %Issue{} = issue
      assert issue.completed == false
      assert issue.description == "some updated description"
      assert issue.time_spent_mins == 43
      assert issue.title == "some updated title"
    end

    test "update_issue/2 with invalid data returns error changeset" do
      issue = issue_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_issue(issue, @invalid_attrs)
      assert issue == Tasks.get_issue!(issue.id)
    end

    test "delete_issue/1 deletes the issue" do
      issue = issue_fixture()
      assert {:ok, %Issue{}} = Tasks.delete_issue(issue)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_issue!(issue.id) end
    end

    test "change_issue/1 returns a issue changeset" do
      issue = issue_fixture()
      assert %Ecto.Changeset{} = Tasks.change_issue(issue)
    end
  end
end
