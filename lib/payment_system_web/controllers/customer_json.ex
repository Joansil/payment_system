defmodule PaymentSystemWeb.CustomerJSON do
  alias PaymentSystem.Accounts.Customer

  @doc """
  Renders a list of customers.
  """
  def index(%{customers: customers}) do
    %{data: for(customer <- customers, do: data(customer))}
  end

  @doc """
  Renders a single customer.
  """
  def show(%{customer: customer}) do
    %{data: data(customer)}
  end

  defp data(%Customer{} = customer) do
    %{
      id: customer.id,
      name: customer.name,
      email: customer.email,
      phone: customer.phone
    }
  end
end
