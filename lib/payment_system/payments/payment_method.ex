defmodule PaymentSystem.Payments.PaymentMethod do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
    type: String.t(),
    provider: String.t(),
    account_number: String.t(),
    is_default: boolean(),
    customer_id: binary_id(),
    customer: Customer.t(),
    transactions: [Transaction.t()],
    inserted_at: DateTime.t(),
    updated_at: DateTime.t()
  }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payment_methods" do
    field :type, :string
    field :provider, :string
    field :account_number, :string
    field :is_default, :boolean, default: false

    belongs_to :customer, PaymentSystem.Accounts.Customer
    has_many :transactions, PaymentSystem.Payments.Transaction

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(payment_method, attrs) do
    payment_method
    |> cast(attrs, [:type, :provider, :account_number, :is_default, :customer_id])
    |> validate_required([:type, :provider, :account_number, :customer_id])
    |> foreign_key_constraint(:customer_id)
  end
end
