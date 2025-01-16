defmodule PaymentSystemWeb.WebhookEndpointJSON do
  alias PaymentSystem.Webhooks.WebhookEndpoint

  @doc """
  Renders a list of webhook_endpoints.
  """
  def index(%{webhook_endpoints: webhook_endpoints}) do
    %{data: for(webhook_endpoint <- webhook_endpoints, do: data(webhook_endpoint))}
  end

  @doc """
  Renders a single webhook_endpoint.
  """
  def show(%{webhook_endpoint: webhook_endpoint}) do
    %{data: data(webhook_endpoint)}
  end

  defp data(%WebhookEndpoint{} = webhook_endpoint) do
    %{
      id: webhook_endpoint.id,
      url: webhook_endpoint.url,
      secret_key: webhook_endpoint.secret_key,
      events: webhook_endpoint.events
    }
  end
end
