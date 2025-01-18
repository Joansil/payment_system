defmodule PaymentSystem.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :email, :string
      add :password_hash, :string
      add :role, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
