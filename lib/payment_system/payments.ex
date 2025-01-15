defmodule PaymentSystem.Payments do
  @moduledoc """
  The Payments context handles all payment-related operations.
  """

  import Ecto.Query, warn: false
  alias PaymentSystem.Repo
  alias PaymentSystem.Payments.Transaction
  alias PaymentSystem.Accounts.Customer

  @doc """
  Creates a transaction.
  """
  @spec create_transaction(map()) :: {:ok, Transaction.t()} | {:error, Ecto.Changeset.t()}
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.
  """
  @spec update_transaction(Transaction.t(), map()) :: {:ok, Transaction.t()} | {:error, Ecto.Changeset.t()}
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Gets a transaction by ID.
  """
  @spec get_transaction!(binary()) :: Transaction.t() | nil
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Gets a transaction by external ID.
  """
  @spec get_transaction_by_external_id(String.t()) :: Transaction.t() | nil
  def get_transaction_by_external_id(external_id) do
    Transaction
    |> where([t], t.external_id == ^external_id)
    |> Repo.one()
  end

  @doc """
  Lists all transactions for a customer.
  """
  @spec list_customer_transactions(binary()) :: [Transaction.t()]
  def list_customer_transactions(customer_id) do
    Transaction
    |> where([t], t.customer_id == ^customer_id)
    |> Repo.all()
  end
end
