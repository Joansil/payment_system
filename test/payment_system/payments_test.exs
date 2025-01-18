defmodule PaymentSystem.PaymentsTest do
  use PaymentSystem.DataCase

  import PaymentSystem.PaymentsFixtures
  alias PaymentSystem.Payments
  alias PaymentSystem.Payments.Transaction
  alias PaymentSystem.Payments.PaymentMethod
  alias Ecto.UUID

  describe "transactions" do
    @invalid_attrs %{
      amount: nil,
      currency: nil,
      customer_id: nil,
      metadata: nil,
      status: nil
    }

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Payments.list_transactions() == [transaction]
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{
        amount: 100,
        currency: "USD",
        customer_id: UUID.generate(),
        metadata: %{},
        status: "pending"
      }

      assert {:ok, %Transaction{} = transaction} = Payments.create_transaction(valid_attrs)
      assert transaction.amount == 100
      assert transaction.currency == "USD"
      assert transaction.customer_id == valid_attrs.customer_id
      assert transaction.metadata == %{}
      assert transaction.status == "pending"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      update_attrs = %{
        amount: 200,
        currency: "EUR",
        customer_id: UUID.generate(),
        metadata: %{"key" => "value"},
        status: "completed"
      }

      assert {:ok, %Transaction{} = transaction} =
               Payments.update_transaction(transaction, update_attrs)

      assert transaction.amount == 200
      assert transaction.currency == "EUR"
      assert transaction.customer_id == update_attrs.customer_id
      assert transaction.metadata == %{"key" => "value"}
      assert transaction.status == "completed"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Payments.update_transaction(transaction, @invalid_attrs)

      assert transaction == Payments.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Payments.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Payments.change_transaction(transaction)
    end
  end

  describe "payment_methods" do
    @invalid_attrs %{
      account_number: nil,
      is_default: nil,
      provider: nil,
      type: nil,
      customer_id: UUID.generate()
    }

    test "list_payment_methods/0 returns all payment_methods" do
      payment_method = payment_method_fixture()
      assert Payments.list_payment_methods() == [payment_method]
    end

    test "create_payment_method/1 with valid data creates a payment_method" do
      valid_attrs = %{
        type: "credit_card",
        provider: "Visa",
        account_number: "1234567890",
        is_default: true,
        customer_id: UUID.generate()
      }

      assert {:ok, %PaymentMethod{} = payment_method} =
               Payments.create_payment_method(valid_attrs)

      assert payment_method.type == "credit_card"
      assert payment_method.provider == "Visa"
      assert payment_method.account_number == "1234567890"
      assert payment_method.is_default == true
      assert payment_method.customer_id == valid_attrs.customer_id
    end

    test "create_payment_method/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment_method(@invalid_attrs)
    end

    test "update_payment_method/2 with valid data updates the payment_method" do
      payment_method = payment_method_fixture()

      update_attrs = %{
        type: "debit_card",
        provider: "MasterCard",
        account_number: "0987654321",
        is_default: false,
        customer_id: UUID.generate()
      }

      assert {:ok, %PaymentMethod{} = payment_method} =
               Payments.update_payment_method(payment_method, update_attrs)

      assert payment_method.type == "debit_card"
      assert payment_method.provider == "MasterCard"
      assert payment_method.account_number == "0987654321"
      assert payment_method.is_default == false
      assert payment_method.customer_id == update_attrs.customer_id
    end

    test "update_payment_method/2 with invalid data returns error changeset" do
      payment_method = payment_method_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Payments.update_payment_method(payment_method, @invalid_attrs)

      assert payment_method == Payments.get_payment_method!(payment_method.id)
    end

    test "delete_payment_method/1 deletes the payment_method" do
      payment_method = payment_method_fixture()
      assert {:ok, %PaymentMethod{}} = Payments.delete_payment_method(payment_method)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment_method!(payment_method.id) end
    end

    test "change_payment_method/1 returns a payment_method changeset" do
      payment_method = payment_method_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment_method(payment_method)
    end
  end
end
