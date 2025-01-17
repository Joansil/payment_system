defmodule PaymentSystemWeb.UserControllerTest do
  use PaymentSystemWeb.ConnCase

  import PaymentSystem.AccountsFixtures
  alias PaymentSystem.Accounts.User
  alias PaymentSystem.Repo
  alias PaymentSystemWeb.Router.Helpers, as: Routes

  @create_attrs %{
    email: "test@example.com",
    password: "strong_password",
    role: "user"
  }
  @update_attrs %{
    email: "updated@example.com",
    password: "updated_password",
    role: "admin"
  }
  @invalid_attrs %{email: "invalid-email", password: nil, role: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_register_path(conn, :create), user: @create_attrs)
      assert %{"id" => id, "email" => email, "token" => token} = json_response(conn, 201)

      assert %User{email: ^email} = Repo.get(User, id)
      assert String.length(token) > 0
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_register_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login user" do
    setup [:create_user]

    test "returns token when credentials are valid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.user_register_path(conn, :login),
          email: user.email,
          password: "strong_password"
        )

      assert %{"token" => token} = json_response(conn, 201)
      assert String.length(token) > 0
    end

    test "renders errors when credentials are invalid", %{conn: conn} do
      conn =
        post(conn, Routes.user_register_path(conn, :login),
          email: "wrong@email.com",
          password: "wrong_password"
        )

      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "authenticated endpoints" do
    setup [:create_user, :authenticate_conn]

    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_register_path(conn, :index))
      assert json_response(conn, 201)["data"] |> length() > 0
    end

    test "shows user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_register_path(conn, :show, user))
      assert json_response(conn, 201)["data"]["id"] == user.id
    end

    test "updates user", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_register_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      assert id == user.id
    end

    test "deletes user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_register_path(conn, :delete, user))
      assert response(conn, 204)
      assert Repo.get(User, user.id) == nil
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp authenticate_conn(%{conn: conn, user: user}) do
    {:ok, token, _} = PaymentSystemWeb.Auth.Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")
    %{conn: conn}
  end
end
