defmodule PaymentSystemWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :payment_system,
    module: PaymentSystemWeb.Auth.Guardian,
    error_handler: PaymentSystemWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug :log_token

  defp log_token(conn, _opts) do
    IO.inspect(conn.private[:guardian_token], label: "JWT Token")
    conn
  end

  def call(conn, opts) do
    # Log de todos os cabeçalhos de requisição para inspeção
    IO.inspect(conn.req_headers, label: "Headers")
    # Log do token JWT extraído
    IO.inspect(get_req_header(conn, "authorization"), label: "Authorization Header")
    # Chama o método call do Guardian
    super(conn, opts)
  end

  # def call(conn, opts) do
  #   IO.inspect(get_req_header(conn, "authorization"), label: "Authorization Header")
  #   super(conn, opts)
  # end

  # def call(conn, _opts) do
  #   IO.inspect(conn.req_headers, label: "Headers")
  #   super(conn, _opts)
  # end
end
