defmodule PaymentSystem.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias PaymentSystem.Payments.Transaction

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customers" do
    field :name, :string
    field :email, :string
    field :external_id, :string
    field :status, :string
    has_many :transactions, Transaction

    timestamps()
  end

  @valid_statuses ~w(active inactive blocked)

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :external_id, :status])
    |> validate_required([:name, :email, :status])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_inclusion(:status, @valid_statuses)
    |> unique_constraint(:email)
    |> unique_constraint(:external_id)
  end
end
