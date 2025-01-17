defmodule PaymentSystem.PaymentsTest do
  use PaymentSystem.DataCase

  alias PaymentSystem.Payments

  describe "transactions" do
    alias PaymentSystem.Payments.Transaction

    import PaymentSystem.PaymentsFixtures

    @invalid_attrs %{
      amount: nil,
      currency: nil,
      customer_id: nil,
      external_id: nil,
      metadata: nil,
      status: nil
    }
    @invalid_attrs %{
      amount: nil,
      currency: nil,
      customer_id: nil,
      external_id: nil,
      metadata: nil,
      status: nil
    }

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Payments.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Payments.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{
        amount: "120.5",
        currency: "some currency",
        customer_id: "some customer_id",
        external_id: "some external_id",
        metadata: %{},
        status: "some status"
      }

      assert {:ok, %Transaction{} = transaction} = Payments.create_transaction(valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.currency == "some currency"
      assert transaction.customer_id == "some customer_id"
      assert transaction.external_id == "some external_id"
      assert transaction.metadata == %{}
      assert transaction.status == "some status"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      update_attrs = %{
        amount: "456.7",
        currency: "some updated currency",
        customer_id: "some updated customer_id",
        external_id: "some updated external_id",
        metadata: %{},
        status: "some updated status"
      }

      assert {:ok, %Transaction{} = transaction} =
               Payments.update_transaction(transaction, update_attrs)

      assert transaction.amount == Decimal.new("456.7")
      assert transaction.currency == "some updated currency"
      assert transaction.customer_id == "some updated customer_id"
      assert transaction.external_id == "some updated external_id"
      assert transaction.metadata == %{}
      assert transaction.status == "some updated status"
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
    alias PaymentSystem.Payments.PaymentMethod

    import PaymentSystem.PaymentsFixtures

    @invalid_attrs %{account_number: nil, is_default: nil, provider: nil, type: nil}

    test "list_payment_methods/0 returns all payment_methods" do
      payment_method = payment_method_fixture()
      assert Payments.list_payment_methods() == [payment_method]
    end

    test "get_payment_method!/1 returns the payment_method with given id" do
      payment_method = payment_method_fixture()
      assert Payments.get_payment_method!(payment_method.id) == payment_method
    end

    test "create_payment_method/1 with valid data creates a payment_method" do
      valid_attrs = %{
        account_number: "some account_number",
        is_default: true,
        provider: "some provider",
        type: "some type"
      }

      assert {:ok, %PaymentMethod{} = payment_method} =
               Payments.create_payment_method(valid_attrs)

      assert payment_method.account_number == "some account_number"
      assert payment_method.is_default == true
      assert payment_method.provider == "some provider"
      assert payment_method.type == "some type"
    end

    test "create_payment_method/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment_method(@invalid_attrs)
    end

    test "update_payment_method/2 with valid data updates the payment_method" do
      payment_method = payment_method_fixture()

      update_attrs = %{
        account_number: "some updated account_number",
        is_default: false,
        provider: "some updated provider",
        type: "some updated type"
      }

      assert {:ok, %PaymentMethod{} = payment_method} =
               Payments.update_payment_method(payment_method, update_attrs)

      assert payment_method.account_number == "some updated account_number"
      assert payment_method.is_default == false
      assert payment_method.provider == "some updated provider"
      assert payment_method.type == "some updated type"
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

  describe "transactions" do
    alias PaymentSystem.Payments.Transaction

    import PaymentSystem.PaymentsFixtures

    @invalid_attrs %{amount: nil, currency: nil, metadata: nil, status: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Payments.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Payments.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{
        amount: "120.5",
        currency: "some currency",
        metadata: %{},
        status: "some status"
      }

      assert {:ok, %Transaction{} = transaction} = Payments.create_transaction(valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.currency == "some currency"
      assert transaction.metadata == %{}
      assert transaction.status == "some status"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      update_attrs = %{
        amount: "456.7",
        currency: "some updated currency",
        metadata: %{},
        status: "some updated status"
      }

      assert {:ok, %Transaction{} = transaction} =
               Payments.update_transaction(transaction, update_attrs)

      assert transaction.amount == Decimal.new("456.7")
      assert transaction.currency == "some updated currency"
      assert transaction.metadata == %{}
      assert transaction.status == "some updated status"
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
end
