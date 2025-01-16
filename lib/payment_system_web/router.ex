defmodule PaymentSystemWeb.Router do
  use PaymentSystemWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PaymentSystemWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/customers", CustomerController, except: [:new, :edit]
    resources "/payment_methods", PaymentMethodController, except: [:new, :edit]
    resources "/transactions", TransactionController, except: [:new, :edit]
    resources "/webhook_endpoints", WebhookEndpointController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:payment_system, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: PaymentSystemWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
