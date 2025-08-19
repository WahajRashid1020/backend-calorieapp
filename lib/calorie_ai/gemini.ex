defmodule CalorieAi.Gemini do
  @moduledoc false

  # Fetch the API key at runtime
  defp api_key do
    Application.fetch_env!(:calorie_ai, :gemini_api_key)
  end

  defp model_url do
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=#{api_key()}"
  end

  defp finch_client do
    Application.get_env(:calorie_ai, :finch, CalorieAiFinch)
  end

  def get_calorie_breakdown(ingredients) do
    instruction = """
    You are a helpful and knowledgeable nutritionist AI. Your task is to analyze a user's description of a meal and provide an estimated calorie breakdown.

    - Respond in valid JSON format.
    - Structure: {
        totalCalories: number,
        items: [{ name: string, calories: number,protien: number,carbs: number,fiber: number,fat: number,sugar: number, servingSize: string }],
        feedback: string
      }
    - Be as accurate as possible with your calorie estimations based on the provided details.
    - If a user provides vague information, make reasonable assumptions (e.g., 'a glass of milk' assumes 2% milk).
    - Provide a short, constructive feedback on the meal's nutritional value.
    - Do not include any text outside of the JSON object.
    """

    request_body =
      %{
        "contents" => [
          %{
            "role" => "user",
            "parts" => [
              %{"text" => "#{instruction}\n\nMeal: #{ingredients}"}
            ]
          }
        ],
        "generationConfig" => %{
          "temperature" => 0.2,
          "response_mime_type" => "application/json"
        }
      }
      |> Jason.encode!()

    headers = [{"Content-Type", "application/json"}]

    Finch.build(:post, model_url(), headers, request_body)
    |> Finch.request(finch_client())
    |> handle_response()
  end

  defp handle_response({:ok, %Finch.Response{status: 200, body: body}}) do
    with {:ok, %{"candidates" => [%{"content" => %{"parts" => [%{"text" => json_text}]}} | _]}} <- Jason.decode(body),
         {:ok, parsed_json} <- Jason.decode(json_text) do
      {:ok, parsed_json}
    else
      {:error, reason} ->
        {:error, "Failed to parse Gemini response: #{inspect(reason)}"}

      _ ->
        {:error, "Unexpected response structure from Gemini"}
    end
  end

  defp handle_response({:ok, %Finch.Response{status: status, body: body}}) do
    err_msg =
      case Jason.decode(body) do
        {:ok, %{"error" => %{"message" => msg}}} -> msg
        _ -> "Gemini API returned status #{status}"
      end

    {:error, err_msg}
  end

  defp handle_response({:error, reason}), do: {:error, inspect(reason)}
end
