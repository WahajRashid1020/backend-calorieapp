ExUnit.start()
#Ecto.Adapters.SQL.Sandbox.mode(CalorieAi.Repo, :manual)  # commented out since no DB

Mox.defmock(CalorieAi.MockFinch, for: Finch)
Application.put_env(:calorie_ai, :finch, CalorieAi.MockFinch)
