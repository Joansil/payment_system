defmodule PaymentSystem.Accounts do
  import Ecto.Query, warn: false
  alias PaymentSystem.Repo
  alias PaymentSystem.Accounts.{User, Customer}
  alias PaymentSystemWeb.Auth.Guardian

  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec get_user(Ecto.UUID.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @spec get_user_by_email(String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @spec authenticate_user(String.t(), String.t()) ::
          {:ok, User.t(), String.t()} | {:error, atom()}
  def authenticate_user(email, password) do
    Guardian.authenticate(email, password)
  end

  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @spec list_users(map()) :: [User.t()]
  def list_users(pagination \\ %{}) do
    User
    |> paginate(pagination)
    |> Repo.all()
  end

  # Customer functions
  @spec create_customer(User.t(), map()) :: {:ok, Customer.t()} | {:error, Ecto.Changeset.t()}
  def create_customer(%User{} = user, attrs) do
    attrs = Map.put(attrs, "user_id", user.id)

    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def create_customer(nil, _attrs) do
    {:error, :invalid_user}
  end

  @spec get_customer(Ecto.UUID.t()) :: {:ok, Customer.t()} | {:error, :not_found}
  def get_customer(id) do
    case Repo.get(Customer, id) do
      nil -> {:error, :not_found}
      customer -> {:ok, customer}
    end
  end

  @spec get_customer!(Ecto.UUID.t()) :: Customer.t()
  def get_customer!(id), do: Repo.get!(Customer, id)

  @spec list_customers() :: [Customer.t()]
  def list_customers do
    Repo.all(Customer)
  end

  @spec update_customer(Customer.t(), map()) :: {:ok, Customer.t()} | {:error, Ecto.Changeset.t()}
  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_customer(Customer.t()) :: {:ok, Customer.t()} | {:error, Ecto.Changeset.t()}
  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end

  @spec list_user_customers(User.t()) :: [Customer.t()]
  def list_user_customers(%User{} = user) do
    Customer
    |> where([c], c.user_id == ^user.id)
    |> Repo.all()
  end

  # Helpers
  defp paginate(query, %{"page" => page, "per_page" => per_page}) do
    page = String.to_integer(page)
    per_page = String.to_integer(per_page)

    query
    |> limit(^per_page)
    |> offset(^((page - 1) * per_page))
  end

  defp paginate(query, _), do: query
end
