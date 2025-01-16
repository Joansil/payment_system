defmodule PaymentSystemWeb.PaymentMethodControllerTest do
  use PaymentSystemWeb.ConnCase

  import PaymentSystem.PaymentsFixtures

  alias PaymentSystem.Payments.PaymentMethod

  @create_attrs %{
    account_number: "some account_number",
    is_default: true,
    provider: "some provider",
    type: "some type"
  }
  @update_attrs %{
    account_number: "some updated account_number",
    is_default: false,
    provider: "some updated provider",
    type: "some updated type"
  }
  @invalid_attrs %{account_number: nil, is_default: nil, provider: nil, type: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_methods", %{conn: conn} do
      conn = get(conn, ~p"/api/payment_methods")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment_method" do
    test "renders payment_method when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/payment_methods", payment_method: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/payment_methods/#{id}")

      assert %{
               "id" => ^id,
               "account_number" => "some account_number",
               "is_default" => true,
               "provider" => "some provider",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/payment_methods", payment_method: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment_method" do
    setup [:create_payment_method]

    test "renders payment_method when data is valid", %{conn: conn, payment_method: %PaymentMethod{id: id} = payment_method} do
      conn = put(conn, ~p"/api/payment_methods/#{payment_method}", payment_method: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/payment_methods/#{id}")

      assert %{
               "id" => ^id,
               "account_number" => "some updated account_number",
               "is_default" => false,
               "provider" => "some updated provider",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, payment_method: payment_method} do
      conn = put(conn, ~p"/api/payment_methods/#{payment_method}", payment_method: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment_method" do
    setup [:create_payment_method]

    test "deletes chosen payment_method", %{conn: conn, payment_method: payment_method} do
      conn = delete(conn, ~p"/api/payment_methods/#{payment_method}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/payment_methods/#{payment_method}")
      end
    end
  end

  defp create_payment_method(_) do
    payment_method = payment_method_fixture()
    %{payment_method: payment_method}
  end
end
