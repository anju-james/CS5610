defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    if conn.assigns[:current_user], do: conn |> redirect(to: issue_path(conn, :index)), else: render conn, "index.html"
  end
end
