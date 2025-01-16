defmodule PaymentSystem.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :role, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :role])
    |> validate_required([:email, :password_hash, :role])
    |> unique_constraint(:email)
  end
end
