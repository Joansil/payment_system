defmodule PaymentSystem.AccountsFixturesTest do
  use ExUnit.Case, async: true
  alias PaymentSystem.AccountsFixtures

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PaymentSystem.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(PaymentSystem.Repo, {:shared, self()})
    :ok
  end

  test "user_fixture/1 creates a user with default attributes" do
    user = AccountsFixtures.user_fixture()
    assert user.email
    assert user.password_hash
  end

  test "user_fixture/1 creates a user with custom attributes" do
    custom_attrs = %{email: "custom@example.com", password: "custom_password"}
    user = AccountsFixtures.user_fixture(custom_attrs)
    assert user.email == "custom@example.com"
  end

  test "customer_fixture/1 creates a customer with default attributes" do
    customer = AccountsFixtures.customer_fixture()
    assert customer.email
    assert customer.phone
  end

  test "customer_fixture/1 creates a customer with custom attributes" do
    custom_attrs = %{email: "custom_customer@example.com", name: "Custom Name"}
    customer = AccountsFixtures.customer_fixture(custom_attrs)
    assert customer.email == "custom_customer@example.com"
    assert customer.name == "Custom Name"
  end
end
