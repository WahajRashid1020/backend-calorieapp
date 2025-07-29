defmodule CalorieAiWeb.CalorieController do
  use CalorieAiWeb, :controller

  alias CalorieAi.Gemini

  def analyze(conn, %{"ingredients" => ingredients}) do
    case Gemini.get_calorie_breakdown(ingredients) do
      {:ok, result} ->
        json(conn, %{calories: result})

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{error: "Failed to fetch calorie breakdown", reason: inspect(reason)})
    end
  end
end
