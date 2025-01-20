defmodule PaymentSystem.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          phone: String.t(),
          user_id: Ecto.UUID.t(),
          user: User.t(),
          payment_methods: [PaymentMethod.t()],
          transactions: [Transaction.t()],
          webhook_endpoints: [WebhookEndpoint.t()],
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "customers" do
    field :name, :string
    field :email, :string
    field :phone, :string

    belongs_to :user, PaymentSystem.Accounts.User, type: :binary_id
    has_many :payment_methods, PaymentSystem.Payments.PaymentMethod
    has_many :transactions, PaymentSystem.Payments.Transaction
    has_many :webhook_endpoints, PaymentSystem.Webhooks.WebhookEndpoint

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone, :user_id])
    |> validate_required([:name, :email, :phone, :user_id])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
    |> foreign_key_constraint(:user_id)
  end
end
