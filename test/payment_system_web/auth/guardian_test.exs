defmodule PaymentSystemWeb.Auth.GuardianTest do
  use PaymentSystem.DataCase

  import PaymentSystem.AccountsFixtures
  alias PaymentSystemWeb.Auth.Guardian
  alias PaymentSystem.Accounts

  describe "authenticate/2" do
    test "returns user and token with valid credentials" do
      user = user_fixture(%{password: "valid_password"})

      assert {:ok, authenticated_user, token} =
               Guardian.authenticate(user.email, "valid_password")

      assert authenticated_user.id == user.id
      assert is_binary(token)
    end

    test "returns error with invalid password" do
      user = user_fixture(%{password: "valid_password"})

      assert {:error, :invalid_password} =
               Guardian.authenticate(user.email, "wrong_password")
    end

    test "returns error with invalid email" do
      assert {:error, :user_not_found} =
               Guardian.authenticate("_wrong_email.com", "any_password")
    end
  end

  describe "subject_for_token/2" do
    test "returns user id" do
      user = user_fixture()
      assert {:ok, user_id_string} = Guardian.subject_for_token(user, %{})
      assert user_id_string == to_string(user.id)
    end
  end

  describe "resource_from_claims/1" do
    test "returns user from valid claims" do
      user = user_fixture()
      claims = %{"sub" => user.id}

      assert {:ok, retrieved_user} = Guardian.resource_from_claims(claims)
      assert retrieved_user.id == user.id
    end

    test "returns error for invalid claims" do
      claims = %{"sub" => "invalid_id"}
      assert {:error, :resource_not_found} = Guardian.resource_from_claims(claims)
    end
  end
end
