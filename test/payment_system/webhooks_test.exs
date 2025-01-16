defmodule PaymentSystem.WebhooksTest do
  use PaymentSystem.DataCase

  alias PaymentSystem.Webhooks

  describe "webhook_endpoints" do
    alias PaymentSystem.Webhooks.WebhookEndpoint

    import PaymentSystem.WebhooksFixtures

    @invalid_attrs %{events: nil, secret_key: nil, url: nil}

    test "list_webhook_endpoints/0 returns all webhook_endpoints" do
      webhook_endpoint = webhook_endpoint_fixture()
      assert Webhooks.list_webhook_endpoints() == [webhook_endpoint]
    end

    test "get_webhook_endpoint!/1 returns the webhook_endpoint with given id" do
      webhook_endpoint = webhook_endpoint_fixture()
      assert Webhooks.get_webhook_endpoint!(webhook_endpoint.id) == webhook_endpoint
    end

    test "create_webhook_endpoint/1 with valid data creates a webhook_endpoint" do
      valid_attrs = %{
        events: ["option1", "option2"],
        secret_key: "some secret_key",
        url: "some url"
      }

      assert {:ok, %WebhookEndpoint{} = webhook_endpoint} =
               Webhooks.create_webhook_endpoint(valid_attrs)

      assert webhook_endpoint.events == ["option1", "option2"]
      assert webhook_endpoint.secret_key == "some secret_key"
      assert webhook_endpoint.url == "some url"
    end

    test "create_webhook_endpoint/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Webhooks.create_webhook_endpoint(@invalid_attrs)
    end

    test "update_webhook_endpoint/2 with valid data updates the webhook_endpoint" do
      webhook_endpoint = webhook_endpoint_fixture()

      update_attrs = %{
        events: ["option1"],
        secret_key: "some updated secret_key",
        url: "some updated url"
      }

      assert {:ok, %WebhookEndpoint{} = webhook_endpoint} =
               Webhooks.update_webhook_endpoint(webhook_endpoint, update_attrs)

      assert webhook_endpoint.events == ["option1"]
      assert webhook_endpoint.secret_key == "some updated secret_key"
      assert webhook_endpoint.url == "some updated url"
    end

    test "update_webhook_endpoint/2 with invalid data returns error changeset" do
      webhook_endpoint = webhook_endpoint_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Webhooks.update_webhook_endpoint(webhook_endpoint, @invalid_attrs)

      assert webhook_endpoint == Webhooks.get_webhook_endpoint!(webhook_endpoint.id)
    end

    test "delete_webhook_endpoint/1 deletes the webhook_endpoint" do
      webhook_endpoint = webhook_endpoint_fixture()
      assert {:ok, %WebhookEndpoint{}} = Webhooks.delete_webhook_endpoint(webhook_endpoint)

      assert_raise Ecto.NoResultsError, fn ->
        Webhooks.get_webhook_endpoint!(webhook_endpoint.id)
      end
    end

    test "change_webhook_endpoint/1 returns a webhook_endpoint changeset" do
      webhook_endpoint = webhook_endpoint_fixture()
      assert %Ecto.Changeset{} = Webhooks.change_webhook_endpoint(webhook_endpoint)
    end
  end
end
