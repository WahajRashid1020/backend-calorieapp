defmodule CalorieAiWeb.ConnCase do
  @moduledoc """
  Setup for tests that require a connection.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      @endpoint CalorieAiWeb.Endpoint

      use CalorieAiWeb, :verified_routes

      import Plug.Conn
      import Phoenix.ConnTest
      import CalorieAiWeb.ConnCase
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
