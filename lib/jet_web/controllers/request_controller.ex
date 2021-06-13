defmodule JetWeb.RequestController do
  use JetWeb, :controller
  alias Jet.Request

  def create(conn, %{"sandbox_uuid" => sandbox_uuid}) do
    case Request.add_request(conn, sandbox_uuid) do
      {:ok, response} ->
        json(conn, response)

      {:error, _} ->
        return_sandbox_not_found_response(conn)
    end
  end

  def return_sandbox_not_found_response(conn) do
    json(conn, %{message: "Sandbox does not exist"})
  end
end
