defmodule PaymentSystem.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :external_id, :string
      add :amount, :decimal
      add :currency, :string
      add :status, :string
      add :customer_id, :string
      add :metadata, :map

      timestamps(type: :utc_datetime)
    end
  end
end
