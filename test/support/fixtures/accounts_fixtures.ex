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

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        password_hash: "some password_hash",
        role: "some role"
      })
      |> PaymentSystem.Accounts.create_user()

    user
  end

  @doc """
  Generate a unique customer email.
  """
  def unique_customer_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        email: unique_customer_email(),
        name: "some name",
        phone: "some phone"
      })
      |> PaymentSystem.Accounts.create_customer()

    customer
  end
end
