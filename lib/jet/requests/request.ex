defmodule Jet.Requests.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :endpoint, :string
    field :http_method, :string
    field :request_body, :map
    field :request_header, :map
    belongs_to :sandbox, Jet.Sandboxes.Sandbox

    timestamps()
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:endpoint, :request_body, :http_method, :request_header])
    |> validate_required([:endpoint, :request_body, :http_method, :request_header])
  end
end
