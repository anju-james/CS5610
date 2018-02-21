defmodule TasktrackerWeb.Router do
  use TasktrackerWeb, :router

  import Tasktracker.TaskPlugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TasktrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/issues", IssueController, only: [:create, :new, :edit, :update, :show, :index]
    resources "/users", UserController, only: [:create, :new]
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete

  end

  # Other scopes may use custom stacks.
  # scope "/api", TasktrackerWeb do
  #   pipe_through :api
  # end
end
