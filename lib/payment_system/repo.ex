defmodule PaymentSystem.Repo do
  use Ecto.Repo,
    otp_app: :payment_system,
    adapter: Ecto.Adapters.Postgres
end
