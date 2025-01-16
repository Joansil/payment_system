defmodule PaymentSystem.AccountsTest do
  use PaymentSystem.DataCase

  alias PaymentSystem.Accounts
  import PaymentSystem.AccountsFixtures

  describe "users" do
    @valid_attrs %{
      email: "test@example.com",
      password: "strong_password",
      role: "user"
    }
    @update_attrs %{
      email: "updated@example.com",
      password: "updated_password"
    }
    @invalid_attrs %{email: nil, password: nil}

    test "create_user/1 with valid data creates a user" do
      assert {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.email == "test@example.com"
      assert user.role == "user"
      assert Bcrypt.verify_pass("strong_password", user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "get_user/1 returns the user with given id" do
      user = user_fixture()
      assert {:ok, retrieved_user} = Accounts.get_user(user.id)
      assert retrieved_user.id == user.id
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = user_fixture()
      assert {:ok, retrieved_user} = Accounts.get_user_by_email(user.email)
      assert retrieved_user.id == user.id
    end

    test "authenticate_user/2 authenticates the user" do
      user = user_fixture(%{password: "valid_password"})

      assert {:ok, authenticated_user, token} =
        Accounts.authenticate_user(user.email, "valid_password")

      assert authenticated_user.id == user.id
      assert is_binary(token)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, updated_user} = Accounts.update_user(user, @update_attrs)
      assert updated_user.email == "updated@example.com"
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert {:error, :not_found} = Accounts.get_user(user.id)
    end
  end

  describe "customers" do
    setup do
      user = user_fixture()
      {:ok, user: user}
    end

    @valid_attrs %{
      name: "John Doe",
      email: "john@example.com",
      phone: "1234567890"
    }

    test "create_customer/2 with valid data creates a customer", %{user: user} do
      assert {:ok, customer} = Accounts.create_customer(user, @valid_attrs)
      assert customer.name == "John Doe"
      assert customer.user_id == user.id
    end

    test "list_user_customers/1 returns all user customers", %{user: user} do
      customer = customer_fixture(user)
      customers = Accounts.list_user_customers(user)
      assert length(customers) == 1
      assert hd(customers).id == customer.id
    end
  end
end
