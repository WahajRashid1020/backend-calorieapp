defmodule CalorieAi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
  children = [
  CalorieAiWeb.Telemetry,
  {Phoenix.PubSub, name: CalorieAi.PubSub},
  CalorieAiWeb.Endpoint,
  {Finch, name: CalorieAiFinch}
  ]


    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CalorieAi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CalorieAiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
