defmodule Qwerty.Repo do
  use Ecto.Repo,
    otp_app: :qwerty,
    adapter: Ecto.Adapters.Postgres
end
