defmodule CalorieAiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :calorie_ai


  plug CORSPlug,
  origin: ["https://mymealapp.vercel.app/"],
  methods: ["GET", "POST", "OPTIONS"],
  headers: ["Content-Type", "Authorization"]

  # Serve static files from "priv/static" if needed later (e.g., frontend assets)
  plug Plug.Static,
    at: "/",
    from: :calorie_ai,
    gzip: false,
    only: ~w()

  # Code reloading (only in dev)
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :calorie_ai
  end

  # Remove LiveDashboard logger (API doesn’t need it)
  # plug Phoenix.LiveDashboard.RequestLogger

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # Remove Plug.Session and socket config — unnecessary for API
  plug CalorieAiWeb.Router
end
