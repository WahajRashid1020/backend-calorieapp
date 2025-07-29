defmodule CalorieAi.GeminiTest do
  use ExUnit.Case, async: true
  import Mox

  setup :verify_on_exit!

  @valid_response_body Jason.encode!(%{
    "candidates" => [
      %{
        "content" => %{
          "parts" => [
            %{
              "text" => Jason.encode!(%{
                "totalCalories" => 500,
                "items" => [
                  %{"name" => "Chicken Breast", "calories" => 300, "servingSize" => "200g"},
                  %{"name" => "Rice", "calories" => 200, "servingSize" => "1 cup"}
                ],
                "feedback" => "This meal provides a good balance of protein and carbs."
              })
            }
          ]
        }
      }
    ]
  })

  test "get_calorie_breakdown/1 returns parsed JSON on success" do
    CalorieAi.MockFinch
    |> expect(:request, fn _request, _client ->
      {:ok, %Finch.Response{status: 200, body: @valid_response_body}}
    end)

    ingredients = "Grilled chicken breast with rice"
    assert {:ok, %{"totalCalories" => 500}} = CalorieAi.Gemini.get_calorie_breakdown(ingredients)
  end

  test "returns error when response is malformed" do
    CalorieAi.MockFinch
    |> expect(:request, fn _request, _client ->
      {:ok, %Finch.Response{status: 200, body: "invalid json"}}
    end)

    assert {:error, _} = CalorieAi.Gemini.get_calorie_breakdown("Pizza")
  end

  test "returns error on non-200 response with API error message" do
    error_body = Jason.encode!(%{error: %{message: "API Key Invalid"}})

    CalorieAi.MockFinch
    |> expect(:request, fn _request, _client ->
      {:ok, %Finch.Response{status: 403, body: error_body}}
    end)

    assert {:error, "API Key Invalid"} = CalorieAi.Gemini.get_calorie_breakdown("Burger")
  end

  test "returns error on HTTP failure" do
    CalorieAi.MockFinch
    |> expect(:request, fn _request, _client ->
      {:error, :timeout}
    end)

    assert {:error, _} = CalorieAi.Gemini.get_calorie_breakdown("Steak")
  end
end
