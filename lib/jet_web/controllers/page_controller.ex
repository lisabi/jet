defmodule JetWeb.PageController do
  use JetWeb, :controller
  alias Jet.{Repo, Sandbox, Request}
  import Ecto.Query

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_sandbox(conn, _params) do
    {:ok, sandbox} = Repo.insert(%Sandbox{})
    conn |> redirect(to: Routes.page_path(conn, :view_sandbox, sandbox.sandbox_uuid))
  end

  def view_sandbox(conn, %{"sandbox_uuid" => sandbox_uuid}) do
    url = Routes.page_url(conn, :index)
    sandbox = Repo.get_by(Sandbox, sandbox_uuid: sandbox_uuid)

    render(conn, "view_sandbox.html", sandbox_uuid: sandbox_uuid, url: url, sandbox_id: sandbox.id)
  end

  def fetch_sample_responses(conn, %{"sandbox_id" => sandbox_id}) do
    # IO.inspect(sandbox_id, label: "Sandbox Id")

    query =
      from(r in Request,
        where: r.sandbox_id == ^sandbox_id
      )

    requests = Repo.all(query)
    render(conn, "view_sandbox.json", %{requests: requests})
  end

  def post_handle(conn, %{"sandbox_uuid" => sandbox_uuid}) do
    add_request(conn, sandbox_uuid)
  end

  def get_handle(conn, _) do
    IO.inspect(conn)
    text(conn, "hello")
  end

  def add_request(conn, sandbox_uuid) do
    case Repo.get_by(Sandbox, sandbox_uuid: sandbox_uuid) do
      %Sandbox{} = sandbox ->
        headers = Enum.into(conn.req_headers, %{})
        http_method = conn.method
        body_params = conn.body_params
        endpoint = conn.request_path

        request =
          Ecto.build_assoc(sandbox, :requests,
            endpoint: endpoint,
            request_body: body_params,
            http_method: http_method,
            request_header: headers
          )

        {:ok, item} = Repo.insert(request)

        JetWeb.Endpoint.broadcast("requests:#{item.sandbox_id}", "response:new", %{
          request: %{
            method: item.http_method,
            endpoint: item.endpoint,
            date: item.inserted_at,
            request_body: item.request_body,
            sandbox_id: item.sandbox_id
          }
        })

        json(conn, %{endpoint: endpoint, body: body_params})

      nil ->
        return_sandbox_not_found_response(conn)
    end
  end

  def return_sandbox_not_found_response(conn) do
    json(conn, %{message: "Sandbox does not exist"})
  end
end
