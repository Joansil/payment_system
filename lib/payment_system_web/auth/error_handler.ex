defmodule PaymentSystemWeb.Auth.ErrorHandler do
  use Phoenix.Controller
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{error: to_string(type)})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, body)
  end

  # def auth_error(conn, {_type, reason}, _opts) do
  #   conn
  #   |> put_status(:unauthorized)
  #   |> json(%{error: "unauthenticated", reason: reason})
  # end
end
