defmodule PaymentSystem.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PaymentSystem.Accounts` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        email: "some email",
        external_id: "some external_id",
        name: "some name",
        status: "some status"
      })
      |> PaymentSystem.Accounts.create_customer()

    customer
  end
end
