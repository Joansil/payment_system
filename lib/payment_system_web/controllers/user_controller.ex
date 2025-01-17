defmodule PaymentSystemWeb.UserController do
  use PaymentSystemWeb, :controller

  alias PaymentSystem.Accounts
  alias PaymentSystem.Accounts.User
  alias PaymentSystemWeb.Auth.Guardian

  action_fallback PaymentSystemWeb.FallbackController

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      #  {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      # token: token})
      |> render("user_token.json", %{user: user})
    end
  end

  @spec login(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Accounts.authenticate_user(email, password) do
      conn
      |> put_status(:ok)
      |> render("user_token.json", %{user: user, token: token})
    end
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    pagination = Map.get(params, "page", %{})
    users = Accounts.list_users(pagination)
    render(conn, "index.json", users: users)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id) do
      render(conn, "show.json", user: user)
    end
  end

  @spec update(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- Accounts.get_user(id),
         {:ok, %User{} = updated_user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: updated_user)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- Accounts.get_user(id),
         {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
