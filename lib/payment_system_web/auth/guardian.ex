defmodule PaymentSystemWeb.Auth.Guardian do
  use Guardian, otp_app: :payment_system

  alias PaymentSystem.Accounts
  alias PaymentSystem.Accounts.User

  @spec subject_for_token(any(), any()) :: {:ok, String.t()}
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  @spec resource_from_claims(map()) ::
          {:ok, %User{}} | {:error, :resource_not_found}
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      {:ok, user} -> {:ok, user}
      _ -> {:error, :resource_not_found}
    end
  end

  def resource_from_claims(claims) do
    user = PaymentSystem.Accounts.get_user(claims["sub"])
    {:ok, user}
  end

  @spec authenticate(String.t(), String.t()) ::
          {:ok, %PaymentSystem.Accounts.User{}, String.t()} | {:error, atom()}
  def authenticate(email, password) do
    with {:ok, user} <- Accounts.get_user_by_email(email),
         true <- verify_password(password, user.password_hash),
         {:ok, token, _claims} <- encode_and_sign(user) do
      {:ok, user, token}
    else
      false -> {:error, :invalid_password}
      {:error, _reason} -> {:error, :user_not_found}
    end
  end

  defp verify_password(password, stored_hash) do
    Bcrypt.verify_pass(password, stored_hash)
  end
end
