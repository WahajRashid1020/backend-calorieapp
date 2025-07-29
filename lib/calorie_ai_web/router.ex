defmodule CalorieAiWeb.Router do
  use CalorieAiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CalorieAiWeb do
    pipe_through :api

    post "/calories", CalorieController, :analyze
  end


  # Commented out LiveDashboard and Mailbox Preview for API-only
  # You can re-enable them if you add HTML support and required plugs

  # if Application.compile_env(:calorie_ai, :dev_routes) do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/dev" do
  #     pipe_through [:fetch_session, :protect_from_forgery]

  #     live_dashboard "/dashboard", metrics: CalorieAiWeb.Telemetry
  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
