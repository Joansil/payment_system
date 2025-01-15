defmodule PaymentSystem.AccountsTest do
  use PaymentSystem.DataCase

  alias PaymentSystem.Accounts

  describe "customers" do
    alias PaymentSystem.Accounts.Customer

    import PaymentSystem.AccountsFixtures

    @invalid_attrs %{email: nil, external_id: nil, name: nil, status: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Accounts.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Accounts.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{email: "some email", external_id: "some external_id", name: "some name", status: "some status"}

      assert {:ok, %Customer{} = customer} = Accounts.create_customer(valid_attrs)
      assert customer.email == "some email"
      assert customer.external_id == "some external_id"
      assert customer.name == "some name"
      assert customer.status == "some status"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      update_attrs = %{email: "some updated email", external_id: "some updated external_id", name: "some updated name", status: "some updated status"}

      assert {:ok, %Customer{} = customer} = Accounts.update_customer(customer, update_attrs)
      assert customer.email == "some updated email"
      assert customer.external_id == "some updated external_id"
      assert customer.name == "some updated name"
      assert customer.status == "some updated status"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_customer(customer, @invalid_attrs)
      assert customer == Accounts.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Accounts.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Accounts.change_customer(customer)
    end
  end
end
