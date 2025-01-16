defmodule PaymentSystemWeb.PaymentMethodJSON do
  alias PaymentSystem.Payments.PaymentMethod

  @doc """
  Renders a list of payment_methods.
  """
  def index(%{payment_methods: payment_methods}) do
    %{data: for(payment_method <- payment_methods, do: data(payment_method))}
  end

  @doc """
  Renders a single payment_method.
  """
  def show(%{payment_method: payment_method}) do
    %{data: data(payment_method)}
  end

  defp data(%PaymentMethod{} = payment_method) do
    %{
      id: payment_method.id,
      type: payment_method.type,
      provider: payment_method.provider,
      account_number: payment_method.account_number,
      is_default: payment_method.is_default
    }
  end
end
