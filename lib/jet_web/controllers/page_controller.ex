defmodule JetWeb.PageController do
  use JetWeb, :controller
  alias Jet.Sandbox

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_sandbox(conn, _params) do
    {:ok, sandbox} = Sandbox.create()
    conn |> redirect(to: Routes.sandbox_path(conn, :show, sandbox.sandbox_uuid))
  end
end
