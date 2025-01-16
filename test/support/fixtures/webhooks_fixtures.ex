defmodule PaymentSystem.WebhooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PaymentSystem.Webhooks` context.
  """

  @doc """
  Generate a webhook_endpoint.
  """
  def webhook_endpoint_fixture(attrs \\ %{}) do
    {:ok, webhook_endpoint} =
      attrs
      |> Enum.into(%{
        events: ["option1", "option2"],
        secret_key: "some secret_key",
        url: "some url"
      })
      |> PaymentSystem.Webhooks.create_webhook_endpoint()

    webhook_endpoint
  end
end
