defmodule CalorieAiWeb.CalorieControllerTest do
  use CalorieAiWeb.ConnCase

  @tag :integration
  test "POST /api/calories returns result", %{conn: conn} do
    conn = post(conn, "/api/calories", %{ingredients: "chicken breast, broccoli, olive oil"})
    assert json_response(conn, 200)["result"]
  end
end
