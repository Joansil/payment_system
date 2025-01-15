defmodule PaymentSystemWeb.TransactionJSON do
  alias PaymentSystem.Payments.Transaction

  @doc """
  Renders a list of transactions.
  """
  def index(%{transactions: transactions}) do
    %{data: for(transaction <- transactions, do: data(transaction))}
  end

  @doc """
  Renders a single transaction.
  """
  def show(%{transaction: transaction}) do
    %{data: data(transaction)}
  end

  defp data(%Transaction{} = transaction) do
    %{
      id: transaction.id,
      external_id: transaction.external_id,
      amount: transaction.amount,
      currency: transaction.currency,
      status: transaction.status,
      customer_id: transaction.customer_id,
      metadata: transaction.metadata
    }
  end
end
