defmodule PaymentSystem.Payments.PaymentMethod do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payment_methods" do
    field :account_number, :string
    field :is_default, :boolean, default: false
    field :provider, :string
    field :type, :string
    field :customer_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment_method, attrs) do
    payment_method
    |> cast(attrs, [:type, :provider, :account_number, :is_default])
    |> validate_required([:type, :provider, :account_number, :is_default])
  end
end
