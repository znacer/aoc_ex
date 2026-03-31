defmodule AocEx.Repo do
  use Ecto.Repo,
    otp_app: :aoc_ex,
    adapter: Ecto.Adapters.Postgres
end
