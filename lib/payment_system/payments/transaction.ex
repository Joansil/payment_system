defmodule PaymentSystem.Payments.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias PaymentSystem.Accounts.Customer

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :external_id, :string
    field :amount, :decimal
    field :currency, :string
    field :status, :string
    field :metadata, :map
    belongs_to :customer, Customer

    timestamps()
  end

  @valid_statuses ~w(pending processing completed failed cancelled)
  @valid_currencies ~w(USD EUR BRL)

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:external_id, :amount, :currency, :status, :customer_id, :metadata])
    |> validate_required([:amount, :currency, :status, :customer_id])
    |> validate_number(:amount, greater_than: 0)
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_inclusion(:currency, @valid_currencies)
    |> foreign_key_constraint(:customer_id)
    |> unique_constraint(:external_id)
  end
end
