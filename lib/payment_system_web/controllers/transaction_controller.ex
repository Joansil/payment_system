defmodule PaymentSystemWeb.TransactionController do
  use PaymentSystemWeb, :controller

  alias PaymentSystem.Payments
  alias PaymentSystem.Payments.Transaction

  action_fallback PaymentSystemWeb.FallbackController

  def index(conn, _params) do
    transactions = Payments.list_transactions()
    render(conn, :index, transactions: transactions)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Payments.create_transaction(transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/transactions/#{transaction}")
      |> render(:show, transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Payments.get_transaction!(id)
    render(conn, :show, transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Payments.get_transaction!(id)

    with {:ok, %Transaction{} = transaction} <-
           Payments.update_transaction(transaction, transaction_params) do
      render(conn, :show, transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Payments.get_transaction!(id)

    with {:ok, %Transaction{}} <- Payments.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
