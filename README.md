# CalorieAI - Phoenix API Backend

This is the Elixir/Phoenix backend for CalorieAI. It exposes an API that accepts a food description and returns a detailed calorie breakdown using Google's Gemini Pro AI model.

## 🚀 Live Deployment

- 🌐 API URL: [https://backend-calorieapp-1.onrender.com/api/calories](https://backend-calorieapp-1.onrender.com/api/calories)

## 🔧 Technologies Used

- Elixir + Phoenix (API only)
- Finch (HTTP client)
- Gemini AI API (text model)
- Mox (test mocking)
- ExUnit (unit and integration testing)
- CORSPlug

## 📦 Installation & Setup

```bash
# Install dependencies
mix deps.get

# Set environment variables
cp .env.dev .env
source .env.dev

# Run tests
mix test

# Run server
mix phx.server
```
