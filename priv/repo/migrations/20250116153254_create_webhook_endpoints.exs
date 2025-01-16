defmodule PaymentSystem.Repo.Migrations.CreateWebhookEndpoints do
  use Ecto.Migration

  def change do
    create table(:webhook_endpoints) do
      add :url, :string
      add :secret_key, :string
      add :events, {:array, :string}
      add :customer_id, references(:customers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:webhook_endpoints, [:customer_id])
  end
end
