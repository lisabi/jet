defmodule Jet.Request do
  @moduledoc """
  Request Context
  """
  alias Jet.Sandbox
  alias Jet.Sandboxes.Sandbox
  alias Jet.Repo

  @spec add_request(%Plug.Conn{}, String.t()) :: {:ok, Map.t()} | {:error}
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

        {:ok, %{endpoint: endpoint, body: body_params}}

      nil ->
        {:error}
    end
  end

  def view do
  end
end
