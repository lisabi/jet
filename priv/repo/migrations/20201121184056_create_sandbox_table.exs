defmodule Jet.Repo.Migrations.CreateSandboxTable do
  use Ecto.Migration

  def change do
    create table("sandboxes") do
      add :sandbox_uuid, :uuid, null: false

      timestamps()
    end
  end

end
