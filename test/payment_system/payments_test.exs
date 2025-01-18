defmodule PaymentSystem.PaymentsTest do
  use PaymentSystem.DataCase

  import PaymentSystem.PaymentsFixtures
  alias PaymentSystem.Payments
  alias PaymentSystem.Payments.{Transaction, PaymentMethod}
  import PaymentSystem.AccountsFixtures
  import PaymentSystem.PaymentsFixtures

  describe "transactions" do
    setup do
      user = user_fixture()
      customer = customer_fixture(user)
      payment_method = payment_method_fixture(customer)

      {:ok, user: user, customer: customer, payment_method: payment_method}
    end

    @valid_attrs %{
      amount: "100.50",
      currency: "USD",
      metadata: %{"description" => "Test payment"}
    }
    @invalid_attrs %{amount: nil, currency: nil}

    test "create_transaction/2 with valid data creates a transaction",
         %{user: user, customer: customer, payment_method: payment_method} do
      attrs = Map.merge(@valid_attrs, %{
        "customer_id" => customer.id,
        "payment_method_id" => payment_method.id
      })

      assert {:ok, %Transaction{} = transaction} = Payments.create_transaction(user, attrs)
      assert transaction.amount == Decimal.new("100.50")
      assert transaction.currency == "USD"
      assert transaction.status == "pending"
    end

    test "create_transaction/2 with invalid data returns error changeset",
         %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Payments.create_transaction(user, @invalid_attrs)
    end

    test "process_transaction/1 processes a valid transaction",
         %{user: user, customer: customer, payment_method: payment_method} do
      transaction = transaction_fixture(user, customer, payment_method)

      assert {:ok, %Transaction{} = processed} = Payments.process_transaction(transaction)
      assert processed.status == "processed"
    end

    test "refund_transaction/2 creates a refund for a processed transaction",
         %{user: user, customer: customer, payment_method: payment_method} do
      transaction = transaction_fixture(user, customer, payment_method, %{status: "processed"})

      assert {:ok, %Transaction{} = refund} =
        Payments.refund_transaction(transaction, "50.25")

      assert refund.type == "refund"
      assert refund.amount == Decimal.new("50.25")
      assert refund.currency == transaction.currency
    end
  end

  describe "payment_methods" do
    setup do
      user = user_fixture()
      customer = customer_fixture(user)
      {:ok, user: user, customer: customer}
    end

    @valid_attrs %{
      type: "credit_card",
      provider: "visa",
      account_number: "4111111111111111"
    }
    @invalid_attrs %{type: nil, provider: nil, account_number: nil}

    test "create_payment_method/1 with valid data creates a payment_method",
         %{customer: customer} do
      attrs = Map.put(@valid_attrs, :customer_id, customer.id)
      assert {:ok, %PaymentMethod{} = payment_method} = Payments.create_payment_method(attrs)
      assert payment_method.type == "credit_card"
      assert payment_method.provider == "visa"
    end

    test "set_default_payment_method/1 sets a payment method as default",
         %{customer: customer} do
      payment_method = payment_method_fixture(customer)
      assert {:ok, updated} = Payments.set_default_payment_method(payment_method)
      assert updated.is_default == true
    end
  end
end
