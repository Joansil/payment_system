defmodule PaymentSystemWeb.WebhookEndpointController do
  use PaymentSystemWeb, :controller

  alias PaymentSystem.Webhooks
  alias PaymentSystem.Webhooks.WebhookEndpoint

  action_fallback PaymentSystemWeb.FallbackController

  def index(conn, _params) do
    webhook_endpoints = Webhooks.list_webhook_endpoints()
    render(conn, :index, webhook_endpoints: webhook_endpoints)
  end

  def create(conn, %{"webhook_endpoint" => webhook_endpoint_params}) do
    with {:ok, %WebhookEndpoint{} = webhook_endpoint} <-
           Webhooks.create_webhook_endpoint(webhook_endpoint_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/webhook_endpoints/#{webhook_endpoint}")
      |> render(:show, webhook_endpoint: webhook_endpoint)
    end
  end

  def show(conn, %{"id" => id}) do
    webhook_endpoint = Webhooks.get_webhook_endpoint!(id)
    render(conn, :show, webhook_endpoint: webhook_endpoint)
  end

  def update(conn, %{"id" => id, "webhook_endpoint" => webhook_endpoint_params}) do
    webhook_endpoint = Webhooks.get_webhook_endpoint!(id)

    with {:ok, %WebhookEndpoint{} = webhook_endpoint} <-
           Webhooks.update_webhook_endpoint(webhook_endpoint, webhook_endpoint_params) do
      render(conn, :show, webhook_endpoint: webhook_endpoint)
    end
  end

  def delete(conn, %{"id" => id}) do
    webhook_endpoint = Webhooks.get_webhook_endpoint!(id)

    with {:ok, %WebhookEndpoint{}} <- Webhooks.delete_webhook_endpoint(webhook_endpoint) do
      send_resp(conn, :no_content, "")
    end
  end
end
