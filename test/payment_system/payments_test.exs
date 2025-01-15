defmodule PaymentSystem.PaymentsTest do
  use PaymentSystem.DataCase

  alias PaymentSystem.Payments

  describe "transactions" do
    alias PaymentSystem.Payments.Transaction

    import PaymentSystem.PaymentsFixtures

    @invalid_attrs %{amount: nil, currency: nil, customer_id: nil, external_id: nil, metadata: nil, status: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Payments.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Payments.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{amount: "120.5", currency: "some currency", customer_id: "some customer_id", external_id: "some external_id", metadata: %{}, status: "some status"}

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
      update_attrs = %{amount: "456.7", currency: "some updated currency", customer_id: "some updated customer_id", external_id: "some updated external_id", metadata: %{}, status: "some updated status"}

      assert {:ok, %Transaction{} = transaction} = Payments.update_transaction(transaction, update_attrs)
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.currency == "some updated currency"
      assert transaction.customer_id == "some updated customer_id"
      assert transaction.external_id == "some updated external_id"
      assert transaction.metadata == %{}
      assert transaction.status == "some updated status"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_transaction(transaction, @invalid_attrs)
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
