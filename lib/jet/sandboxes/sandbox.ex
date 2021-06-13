defmodule Jet.Sandboxes.Sandbox do
  use Ecto.Schema

  schema "sandboxes" do
    field :sandbox_uuid, Ecto.UUID, autogenerate: true
    has_many :requests, Jet.Requests.Request

    timestamps()
  end
end
