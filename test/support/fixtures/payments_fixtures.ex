defmodule PaymentSystem.PaymentsFixtures do

  alias PaymentSystem.Payments

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
        currency: "BRL",
        customer_id: Ecto.UUID.generate().generate(),
        metadata: %{},
        status: "some status"
      })
      |> Payments.create_transaction(attrs)

    transaction
  end

  def transaction_fixture(user, customer, payment_method) do
    attrs = %{
      amount: "120.5",
      currency: "BRL",
      customer_id: customer.id,
      user_id: user.id,
      payment_method_id: payment_method.id,
      metadata: %{},
      status: "some status"
    }

    {:ok, transaction} = Payments.create_transaction(user.id, attrs)
    transaction
  end

  @doc """
  Generate a payment_method.
  """
  def payment_method_fixture(attrs \\ %{}) do
    {:ok, payment_method} =
      attrs
      |> Enum.into(%{
        account_number: "7667321987763-66",
        is_default: true,
        provider: "Great Facility",
        type: "some type",
        customer_id: Ecto.UUID.generate().generate()
      })
      |> PaymentSystem.Payments.create_payment_method()

    payment_method
  end
end
