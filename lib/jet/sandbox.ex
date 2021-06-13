defmodule Jet.Sandbox do
  @moduledoc """
  Request Context
  """

  alias Jet.Repo
  alias Jet.Sandboxes.Sandbox
  alias Jet.Requests.Request
  import Ecto.Query

  def create do
    Repo.insert(%Sandbox{})
  end

  def view_sandbox(sandbox_uuid) do
    Repo.get_by(Sandbox, sandbox_uuid: sandbox_uuid)
  end

  def fetch_sandbox_requests(sandbox_id) do
    query =
      from(r in Request,
        where: r.sandbox_id == ^sandbox_id
      )

    Repo.all(query)
  end
end
