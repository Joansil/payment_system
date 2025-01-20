defmodule PaymentSystemWeb.CustomerController do
  use PaymentSystemWeb, :controller

  alias PaymentSystem.Accounts
  alias PaymentSystem.Accounts.{User, Customer}
  alias PaymentSystemWeb.Auth.Guardian

  action_fallback PaymentSystemWeb.FallbackController

  def index(conn, _params) do
    customers = Accounts.list_customers()
    render(conn, :index, customers: customers)
  end

  def create(conn, %{"customer" => customer_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      with {:ok, %Customer{} = customer} <-
             Accounts.create_customer(current_user, customer_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/customers/#{customer.id}")
        |> render(:show, customer: customer)
      else
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(PaymentSystemWeb.ChangesetJSON, "error.json", changeset: changeset)
      end
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{error: "Unauthorized"})
    end
  end

  def show(conn, %{"id" => id}) do
    customer = Accounts.get_customer!(id)
    render(conn, :show, customer: customer)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Accounts.get_customer!(id)

    with {:ok, %Customer{} = customer} <- Accounts.update_customer(customer, customer_params) do
      render(conn, :show, customer: customer)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Accounts.get_customer!(id)

    with {:ok, %Customer{}} <- Accounts.delete_customer(customer) do
      send_resp(conn, :no_content, "")
    end
  end
end
