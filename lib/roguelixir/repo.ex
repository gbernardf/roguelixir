defmodule Roguelixir.Repo do
  use Ecto.Repo,
    otp_app: :roguelixir,
    adapter: Ecto.Adapters.Postgres
end
