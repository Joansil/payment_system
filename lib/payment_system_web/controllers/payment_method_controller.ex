defmodule PaymentSystemWeb.PaymentMethodController do
  use PaymentSystemWeb, :controller

  alias PaymentSystem.Payments
  alias PaymentSystem.Payments.PaymentMethod

  action_fallback PaymentSystemWeb.FallbackController

  def index(conn, params) do
    payment_methods = Payments.list_payment_methods(params)
    render(conn, :index, payment_methods: payment_methods)
  end

  def create(conn, %{"payment_method" => payment_method_params}) do
    with {:ok, %PaymentMethod{} = payment_method} <-
           Payments.create_payment_method(payment_method_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/payment_methods/#{payment_method}")
      |> render(:show, payment_method: payment_method)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_method = Payments.get_payment_method!(id)
    render(conn, :show, payment_method: payment_method)
  end

  def update(conn, %{"id" => id, "payment_method" => payment_method_params}) do
    payment_method = Payments.get_payment_method!(id)

    with {:ok, %PaymentMethod{} = payment_method} <-
           Payments.update_payment_method(payment_method, payment_method_params) do
      render(conn, :show, payment_method: payment_method)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_method = Payments.get_payment_method!(id)

    with {:ok, %PaymentMethod{}} <- Payments.delete_payment_method(payment_method) do
      send_resp(conn, :no_content, "")
    end
  end
end
