defmodule Jet.Repo do
  use Ecto.Repo,
    otp_app: :jet,
    adapter: Ecto.Adapters.Postgres
end
