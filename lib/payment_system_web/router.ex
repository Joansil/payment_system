defmodule PaymentSystemWeb.Router do
  use PaymentSystemWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug PaymentSystemWeb.Auth.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  # Rotas públicas
  scope "/api", PaymentSystemWeb do
    pipe_through :api

    post "/users/register", UserController, :create
    post "/users/login", UserController, :login
  end

  scope "/api", PaymentSystemWeb do
    pipe_through :api_auth

    # User and Customer Management
    resources "/users", UserController, except: [:new, :edit]
    resources "/customers", CustomerController, except: [:new, :edit]

    # Payment Methods
    resources "/payment_methods", PaymentMethodController, except: [:new, :edit]
    post "/payment_methods/:id/default", PaymentMethodController, :set_default

    # Transactions
    resources "/transactions", TransactionController, only: [:index, :show, :create]
    get "/transactions/:id/status", TransactionController, :check_status
    post "/transactions/:id/refund", TransactionController, :refund

    # Webhooks
    resources "/webhook_endpoints", WebhookEndpointController, except: [:new, :edit]
    post "/webhook_endpoints/:id/test", WebhookEndpointController, :test
  end

  # Development routes
  if Mix.env() in [:dev, :test] do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
