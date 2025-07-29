import Config
import Dotenvy

# Load environment variables from .env and system environment
source!([
  Path.expand(".env"),
  System.get_env()
])

# Fetch and assign GEMINI_API_KEY to app config
config :calorie_ai, gemini_api_key: env!("GEMINI_API_KEY")

IO.inspect(System.get_env("GEMINI_API_KEY"), label: "GEMINI_API_KEY from ENV")

# Enable Phoenix server if PHX_SERVER is set
if System.get_env("PHX_SERVER") do
  config :calorie_ai, CalorieAiWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url = "ecto://postgres:postgres@localhost/dummy" ||
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :calorie_ai, CalorieAi.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") || 10
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :calorie_ai, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY") || 121

  config :calorie_ai, CalorieAiWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end
