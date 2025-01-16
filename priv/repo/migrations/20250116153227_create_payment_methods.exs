defmodule PaymentSystem.Repo.Migrations.CreatePaymentMethods do
  use Ecto.Migration

  def change do
    create table(:payment_methods) do
      add :type, :string
      add :provider, :string
      add :account_number, :string
      add :is_default, :boolean, default: false, null: false
      add :customer_id, references(:customers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:payment_methods, [:customer_id])
  end
end
