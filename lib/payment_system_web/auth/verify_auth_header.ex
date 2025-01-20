defmodule PaymentSystemWeb.Auth.VerifyAuthHeader do
  import Plug.Conn
  alias PaymentSystemWeb.Auth.Guardian

  def init(default), do: default

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, _claims} <- Guardian.decode_and_verify(token) do
      conn
    else
      _ -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end
end
