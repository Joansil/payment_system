defmodule PaymentSystem.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PaymentSystem.Accounts` context.
  """

  alias PaymentSystem.Accounts

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        email: unique_customer_email(),
        name: "some name",
        status: "some status",
        phone: "0112238923798",
        user_id: some_user_id()
      })
      |> Accounts.create_customer()

    customer
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    default_attrs = %{
      email: unique_user_email(),
      password: "password123",
      password_hash: generate_password_hash("password123"),
      role: "some role"
    }

    attrs = Enum.into(attrs, default_attrs)

    {:ok, user} =
      attrs
      |> Map.put(:password_hash, generate_password_hash(attrs[:password]))
      |> Accounts.create_user()

    user
  end

  defp generate_password_hash(password) do
    Bcrypt.hash_pwd_salt(password)
  end

  defp some_user_id do
    user = user_fixture()
    user.id
  end

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "user@example.com#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique customer email.
  """
  def unique_customer_email, do: "customer@example.com#{System.unique_integer([:positive])}"
end
