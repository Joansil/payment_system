defmodule PaymentSystem.Payments.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :currency, :string
    field :customer_id, :string
    field :external_id, :string
    field :metadata, :map
    field :status, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:external_id, :amount, :currency, :status, :customer_id, :metadata])
    |> validate_required([:external_id, :amount, :currency, :status, :customer_id])
  end
end
