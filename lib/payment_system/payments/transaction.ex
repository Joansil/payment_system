defmodule PaymentSystem.Payments.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :currency, :string
    field :metadata, :map
    field :status, :string
    field :customer_id, :id
    field :payment_method_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :currency, :status, :metadata])
    |> validate_required([:amount, :currency, :status])
  end
end
