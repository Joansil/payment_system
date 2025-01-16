defmodule PaymentSystem.Webhooks.WebhookEndpoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "webhook_endpoints" do
    field :events, {:array, :string}
    field :secret_key, :string
    field :url, :string
    field :customer_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(webhook_endpoint, attrs) do
    webhook_endpoint
    |> cast(attrs, [:url, :secret_key, :events])
    |> validate_required([:url, :secret_key, :events])
  end
end
