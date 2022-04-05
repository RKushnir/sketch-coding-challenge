defmodule CanvasClient.HTTPClient do
  alias CanvasClient.Canvas

  def create_canvas do
    case Tesla.post(client(), "/canvases", %{}) do
      {:ok, %Tesla.Env{body: %{"id" => canvas_id}}} ->
        canvas = %Canvas{id: canvas_id}
        {:ok, canvas}

      _error ->
        :error
    end
  end

  defp client do
    base_url = System.get_env("CANVAS_SERVER_URL", "http://localhost:4000")

    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
