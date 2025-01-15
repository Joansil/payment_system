defmodule PaymentSystem.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PaymentSystem.Payments` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        currency: "some currency",
        customer_id: "some customer_id",
        external_id: "some external_id",
        metadata: %{},
        status: "some status"
      })
      |> PaymentSystem.Payments.create_transaction()

    transaction
  end
end
