defmodule PaymentSystem.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.UUID

  @type t :: %__MODULE__{
          email: String.t(),
          password_hash: String.t(),
          role: String.t(),
          customers: [Customer.t()],
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :role, :string

    has_many :customers, PaymentSystem.Accounts.Customer

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :role])
    |> validate_required([:email, :password_hash, :role])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
  end
end
