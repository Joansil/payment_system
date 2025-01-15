defmodule PaymentSystemWeb.TransactionController do
  use PaymentSystemWeb, :controller
  alias PaymentSystem.Payments
  alias PaymentSystem.Payments.Transaction

  action_fallback PaymentSystemWeb.FallbackController

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Payments.create_transaction(transaction_params) do
      conn
      |> put_status(:created)
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Payments.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Payments.get_transaction!(id)

    with {:ok, %Transaction{} = updated_transaction} <-
           Payments.update_transaction(transaction, transaction_params) do
      render(conn, "show.json", transaction: updated_transaction)
    end
  end

  def customer_transactions(conn, %{"customer_id" => customer_id}) do
    transactions = Payments.list_customer_transactions(customer_id)
    render(conn, "index.json", transactions: transactions)
  end
end
