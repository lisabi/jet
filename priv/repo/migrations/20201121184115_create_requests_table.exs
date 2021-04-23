defmodule Jet.Repo.Migrations.CreateRequestsTable do
  use Ecto.Migration

  def change do
    create table("requests") do
      add :endpoint, :string
      add :http_method, :string
      add :request_header, :json
      add :request_body, :json
      add :sandbox_id,  references(:sandboxes)

      timestamps()
    end

    create index(:requests, [:sandbox_id])

  end
end
