defmodule PaymentSystemWeb.WebhookEndpointControllerTest do
  use PaymentSystemWeb.ConnCase

  import PaymentSystem.WebhooksFixtures

  alias PaymentSystem.Webhooks.WebhookEndpoint

  @create_attrs %{
    events: ["option1", "option2"],
    secret_key: "some secret_key",
    url: "some url"
  }
  @update_attrs %{
    events: ["option1"],
    secret_key: "some updated secret_key",
    url: "some updated url"
  }
  @invalid_attrs %{events: nil, secret_key: nil, url: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all webhook_endpoints", %{conn: conn} do
      conn = get(conn, ~p"/api/webhook_endpoints")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create webhook_endpoint" do
    test "renders webhook_endpoint when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/webhook_endpoints", webhook_endpoint: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/webhook_endpoints/#{id}")

      assert %{
               "id" => ^id,
               "events" => ["option1", "option2"],
               "secret_key" => "some secret_key",
               "url" => "some url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/webhook_endpoints", webhook_endpoint: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update webhook_endpoint" do
    setup [:create_webhook_endpoint]

    test "renders webhook_endpoint when data is valid", %{conn: conn, webhook_endpoint: %WebhookEndpoint{id: id} = webhook_endpoint} do
      conn = put(conn, ~p"/api/webhook_endpoints/#{webhook_endpoint}", webhook_endpoint: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/webhook_endpoints/#{id}")

      assert %{
               "id" => ^id,
               "events" => ["option1"],
               "secret_key" => "some updated secret_key",
               "url" => "some updated url"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, webhook_endpoint: webhook_endpoint} do
      conn = put(conn, ~p"/api/webhook_endpoints/#{webhook_endpoint}", webhook_endpoint: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete webhook_endpoint" do
    setup [:create_webhook_endpoint]

    test "deletes chosen webhook_endpoint", %{conn: conn, webhook_endpoint: webhook_endpoint} do
      conn = delete(conn, ~p"/api/webhook_endpoints/#{webhook_endpoint}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/webhook_endpoints/#{webhook_endpoint}")
      end
    end
  end

  defp create_webhook_endpoint(_) do
    webhook_endpoint = webhook_endpoint_fixture()
    %{webhook_endpoint: webhook_endpoint}
  end
end
