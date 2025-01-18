defmodule PaymentSystem.Payments.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          amount: Decimal.t(),
          currency: String.t(),
          status: String.t(),
          type: String.t(),
          metadata: map(),
          customer_id: binary_id(),
          payment_method_id: binary_id(),
          customer: Customer.t(),
          payment_method: PaymentMethod.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :decimal
    field :currency, :string
    field :status, :string
    field :type, :string, default: "payment"
    field :metadata, :map, default: %{}

    belongs_to :customer, PaymentSystem.Accounts.Customer
    belongs_to :payment_method, PaymentSystem.Payments.PaymentMethod

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :amount,
      :currency,
      :status,
      :type,
      :metadata,
      :customer_id,
      :payment_method_id
    ])
    |> validate_required([:amount, :currency, :status, :customer_id, :payment_method_id])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:currency, ["USD", "EUR", "BRL"])
    |> validate_inclusion(:status, ["pending", "processed", "failed", "refunded"])
    |> validate_inclusion(:type, ["payment", "refund"])
    |> foreign_key_constraint(:customer_id)
    |> foreign_key_constraint(:payment_method_id)
  end

  @doc false
  def status_changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> validate_inclusion(:status, ["pending", "processed", "failed", "refunded"])
  end
end
