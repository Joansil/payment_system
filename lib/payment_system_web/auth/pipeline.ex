defmodule PaymentSystemWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :payment_system,
    module: PaymentSystemWeb.Auth.Guardian,
    error_handler: PaymentSystemWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
