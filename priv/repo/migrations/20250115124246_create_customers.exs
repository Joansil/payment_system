defmodule PaymentSystem.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string
      add :email, :string
      add :external_id, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
