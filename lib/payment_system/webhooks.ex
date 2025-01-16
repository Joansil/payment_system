defmodule PaymentSystem.Webhooks do
  @moduledoc """
  The Webhooks context.
  """

  import Ecto.Query, warn: false
  alias PaymentSystem.Repo

  alias PaymentSystem.Webhooks.WebhookEndpoint

  @doc """
  Returns the list of webhook_endpoints.

  ## Examples

      iex> list_webhook_endpoints()
      [%WebhookEndpoint{}, ...]

  """
  def list_webhook_endpoints do
    Repo.all(WebhookEndpoint)
  end

  @doc """
  Gets a single webhook_endpoint.

  Raises `Ecto.NoResultsError` if the Webhook endpoint does not exist.

  ## Examples

      iex> get_webhook_endpoint!(123)
      %WebhookEndpoint{}

      iex> get_webhook_endpoint!(456)
      ** (Ecto.NoResultsError)

  """
  def get_webhook_endpoint!(id), do: Repo.get!(WebhookEndpoint, id)

  @doc """
  Creates a webhook_endpoint.

  ## Examples

      iex> create_webhook_endpoint(%{field: value})
      {:ok, %WebhookEndpoint{}}

      iex> create_webhook_endpoint(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_webhook_endpoint(attrs \\ %{}) do
    %WebhookEndpoint{}
    |> WebhookEndpoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a webhook_endpoint.

  ## Examples

      iex> update_webhook_endpoint(webhook_endpoint, %{field: new_value})
      {:ok, %WebhookEndpoint{}}

      iex> update_webhook_endpoint(webhook_endpoint, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_webhook_endpoint(%WebhookEndpoint{} = webhook_endpoint, attrs) do
    webhook_endpoint
    |> WebhookEndpoint.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a webhook_endpoint.

  ## Examples

      iex> delete_webhook_endpoint(webhook_endpoint)
      {:ok, %WebhookEndpoint{}}

      iex> delete_webhook_endpoint(webhook_endpoint)
      {:error, %Ecto.Changeset{}}

  """
  def delete_webhook_endpoint(%WebhookEndpoint{} = webhook_endpoint) do
    Repo.delete(webhook_endpoint)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking webhook_endpoint changes.

  ## Examples

      iex> change_webhook_endpoint(webhook_endpoint)
      %Ecto.Changeset{data: %WebhookEndpoint{}}

  """
  def change_webhook_endpoint(%WebhookEndpoint{} = webhook_endpoint, attrs \\ %{}) do
    WebhookEndpoint.changeset(webhook_endpoint, attrs)
  end
end
