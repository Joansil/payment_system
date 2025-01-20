defmodule PaymentSystemWeb.UserJSON do
  alias PaymentSystem.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  @doc """
  Renders a user token.
  """
  def user_token(%{token: token}) do
    %{token: token}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      role: user.role
    }
  end
end
