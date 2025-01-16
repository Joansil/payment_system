defmodule PaymentSystem.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal
      add :currency, :string
      add :status, :string
      add :metadata, :map
      add :customer_id, references(:customers, on_delete: :nothing)
      add :payment_method_id, references(:payment_methods, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:customer_id])
    create index(:transactions, [:payment_method_id])
  end
end
