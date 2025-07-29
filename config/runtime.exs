import Config
import Dotenvy

# Load environment variables from .env and system environment
source!([
  Path.expand(".env"),
  System.get_env()
])

# Fetch and assign GEMINI_API_KEY to app config
config :calorie_ai, gemini_api_key: env!("GEMINI_API_KEY")

 
# Enable Phoenix server if PHX_SERVER is set
if System.get_env("PHX_SERVER") do
  config :calorie_ai, CalorieAiWeb.Endpoint, server: true
end

# Production-specific settings (if needed)
if config_env() == :prod do
  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :calorie_ai, CalorieAiWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ]
end
