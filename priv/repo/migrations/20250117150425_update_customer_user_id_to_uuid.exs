defmodule PaymentSystem.Repo.Migrations.UpdateCustomerUserIdToUuid do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      modify :user_id, :binary_id, null: false
    end
  end
end
