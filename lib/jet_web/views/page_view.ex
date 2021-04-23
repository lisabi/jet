defmodule JetWeb.PageView do
  use JetWeb, :view

  def render("view_sandbox.json", %{requests: requests}) do
    render_many(requests, __MODULE__, "request.json")
  end

  def render("request.json", %{page: request}) do
    %{
      method: request.http_method,
      endpoint: request.endpoint,
      # "2020-11-21 20:29:39"
      date: request.inserted_at,
      request_body: request.request_body,
      sandbox_id: request.sandbox_id
    }
  end
end
