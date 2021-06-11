defmodule JetWeb.RuleController do
  use JetWeb, :controller

  def create(conn, _) do
    needed_params = %{
      sandbox_uuid: "",
      method: "",
      path: "path",
      status_code: "",
      response_header: "",
      response_body: "",
      description: ""
    }

    json(conn, needed_params)
  end
end
