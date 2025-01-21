defmodule PaymentSystem.Payments do
  import Ecto.Query, warn: false
  alias PaymentSystem.Repo
  alias PaymentSystem.Payments.{Transaction, PaymentMethod}
  alias PaymentSystem.Accounts.User

  # Transaction functions
  @spec create_transaction(User.t(), map()) ::
          {:ok, Transaction.t()} | {:error, Ecto.Changeset.t()}
  def create_transaction(%User{} = user, attrs) do
    with {:ok, customer_id} <- validate_customer(user, attrs),
         {:ok, payment_method} <- validate_payment_method(customer_id, attrs) do
      attrs =
        attrs
        |> Map.put("status", "pending")
        |> Map.put("customer_id", customer_id)
        |> Map.put("payment_method_id", payment_method.id)

      %Transaction{}
      |> Transaction.changeset(attrs)
      |> Repo.insert()
    end
  end

  @spec update_transaction(Transaction.t(), map()) ::
          {:ok, Transaction.t()} | {:error, Ecto.Changeset.t()}
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @spec process_transaction(Transaction.t()) :: {:ok, Transaction.t()} | {:error, any()}
  def process_transaction(%Transaction{} = transaction) do
    # Simulate payment processing
    # In production, this would integrate with a real payment gateway
    # Simulate API latency
    Process.sleep(1000)

    status =
      if Decimal.compare(transaction.amount, Decimal.new(1000)) == :lt do
        "processed"
      else
        "failed"
      end

    transaction
    |> Transaction.status_changeset(%{status: status})
    |> Repo.update()
  end

  @spec refund_transaction(Transaction.t(), String.t()) ::
          {:ok, Transaction.t()} | {:error, any()}
  def refund_transaction(%Transaction{} = original_transaction, amount) do
    if original_transaction.status != "processed" do
      {:error, :invalid_transaction_status}
    else
      decimal_amount = Decimal.new(amount)

      if Decimal.compare(decimal_amount, original_transaction.amount) == :gt do
        {:error, :refund_amount_too_high}
      else
        attrs = %{
          amount: decimal_amount,
          currency: original_transaction.currency,
          customer_id: original_transaction.customer_id,
          payment_method_id: original_transaction.payment_method_id,
          type: "refund",
          status: "pending",
          metadata:
            Map.put(
              original_transaction.metadata,
              "original_transaction_id",
              original_transaction.id
            )
        }

        create_and_process_refund(attrs)
      end
    end
  end

  @spec get_transaction!(UUID.t()) :: Transaction.t() | no_return()
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @spec get_user_transaction(User.t(), UUID.t()) ::
          {:ok, Transaction.t()} | {:error, :not_found}
  def get_user_transaction(%User{} = user, id) do
    transaction =
      Transaction
      |> join(:inner, [t], c in assoc(t, :customer))
      |> where([t, c], c.user_id == ^user.id and t.id == ^id)
      |> preload([:customer, :payment_method])
      |> Repo.one()

    case transaction do
      nil -> {:error, :not_found}
      transaction -> {:ok, transaction}
    end
  end

  @spec list_transactions(map()) :: [Transaction.t()]
  def list_transactions(params \\ %{}) do
    Transaction
    |> apply_filters(params)
    |> paginate(params)
    |> preload([:customer, :payment_method])
    |> Repo.all()
  end

  defp apply_filters(query, %{"status" => status}) when is_binary(status) do
    from t in query, where: t.status == ^status
  end

  @spec list_user_transactions(User.t(), map()) :: [Transaction.t()]
  def list_user_transactions(%User{} = user, pagination \\ %{}) do
    Transaction
    |> join(:inner, [t], c in assoc(t, :customer))
    |> where([t, c], c.user_id == ^user.id)
    |> preload([:customer, :payment_method])
    |> paginate(pagination)
    |> Repo.all()
  end

  @spec delete_transaction(Transaction.t()) ::
          {:ok, Transaction.t()} | {:error, Ecto.Changeset.t()}
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  # Payment Method functions
  @spec create_payment_method(map()) :: {:ok, PaymentMethod.t()} | {:error, Ecto.Changeset.t()}
  def create_payment_method(attrs \\ %{}) do
    %PaymentMethod{}
    |> PaymentMethod.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_payment_method(PaymentMethod.t(), map()) ::
          {:ok, PaymentMethod.t()} | {:error, Ecto.Changeset.t()}
  def update_payment_method(%PaymentMethod{} = payment_method, attrs) do
    payment_method
    |> PaymentMethod.changeset(attrs)
    |> Repo.update()
  end

  @spec list_payment_methods(Ecto.UUID.t()) :: [PaymentMethod.t()]
  def list_payment_methods(customer_id) do
    PaymentMethod
    |> where([p], p.customer_id == ^customer_id)
    |> Repo.all()
  end

  @spec delete_payment_method(PaymentMethod.t()) ::
          {:ok, PaymentMethod.t()} | {:error, Ecto.Changeset.t()}
  def delete_payment_method(%PaymentMethod{} = payment_method) do
    Repo.delete(payment_method)
  end

  @spec get_payment_method!(UUID.t()) :: PaymentMethod.t() | no_return()
  def get_payment_method!(id), do: Repo.get!(PaymentMethod, id)

  @spec set_default_payment_method(PaymentMethod.t()) ::
          {:ok, PaymentMethod.t()} | {:error, any()}
  def set_default_payment_method(%PaymentMethod{} = payment_method) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.update_all(
        :unset_defaults,
        from(p in PaymentMethod,
          where: p.customer_id == ^payment_method.customer_id
        ),
        set: [is_default: false]
      )
      |> Ecto.Multi.update(
        :set_default,
        PaymentMethod.changeset(payment_method, %{is_default: true})
      )

    case Repo.transaction(multi) do
      {:ok, %{set_default: payment_method}} -> {:ok, payment_method}
      {:error, _operation, changeset, _changes} -> {:error, changeset}
    end
  end

  # Private functions
  defp create_and_process_refund(attrs) do
    with {:ok, transaction} <- %Transaction{} |> Transaction.changeset(attrs) |> Repo.insert(),
         {:ok, processed_transaction} <- process_transaction(transaction) do
      {:ok, processed_transaction}
    end
  end

  defp validate_customer(%User{} = user, %{"customer_id" => customer_id}) do
    case Repo.get_by(Customer, id: customer_id, user_id: user.id) do
      nil -> {:error, :invalid_customer}
      _customer -> {:ok, customer_id}
    end
  end

  defp validate_customer(_user, _attrs), do: {:error, :customer_id_required}

  defp validate_payment_method(customer_id, %{"payment_method_id" => payment_method_id}) do
    case Repo.get_by(PaymentMethod, id: payment_method_id, customer_id: customer_id) do
      nil -> {:error, :invalid_payment_method}
      payment_method -> {:ok, payment_method}
    end
  end

  defp validate_payment_method(_customer_id, _attrs), do: {:error, :payment_method_id_required}

  defp paginate(query, %{"page" => page, "per_page" => per_page}) do
    page = String.to_integer(page)
    per_page = String.to_integer(per_page)

    query
    |> limit(^per_page)
    |> offset(^((page - 1) * per_page))
  end

  defp paginate(query, _), do: query
end
