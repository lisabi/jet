defmodule JetWeb.SandboxController do
  use JetWeb, :controller
  alias(Jet.Sandbox)

  def show(conn, %{"sandbox_uuid" => sandbox_uuid}) do
    url = Routes.page_url(conn, :index)
    sandbox = Sandbox.view_sandbox(sandbox_uuid)

    render(conn, "show.html", sandbox_uuid: sandbox_uuid, url: url, sandbox_id: sandbox.id)
  end

  def fetch_requests(conn, %{"sandbox_id" => sandbox_id}) do
    requests = Sandbox.fetch_sandbox_requests(sandbox_id)

    render(conn, "view_sandbox.json", %{requests: requests})
  end
end
