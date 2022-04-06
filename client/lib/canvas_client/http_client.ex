defmodule CanvasClient.HTTPClient do
  @behaviour CanvasClient.HTTPClientBehaviour
  alias CanvasClient.Canvas

  @impl CanvasClient.HTTPClientBehaviour
  def create_canvas do
    case Tesla.post(client(), "/canvases", %{}) do
      {:ok, %Tesla.Env{body: %{"id" => canvas_id}}} ->
        canvas = %Canvas{id: canvas_id}
        {:ok, canvas}

      _error ->
        :error
    end
  end

  @impl CanvasClient.HTTPClientBehaviour
  def draw_rectangle(attrs) do
    canvas_id = attrs[:canvas_id]

    payload =
      Map.take(attrs, [
        :offset_top,
        :offset_left,
        :height,
        :width,
        :fill_character,
        :outline_character
      ])

    case Tesla.post(client(), "/canvases/#{canvas_id}/rectangles", payload) do
      {:ok, %Tesla.Env{status: 200}} ->
        :ok

      {:ok, %Tesla.Env{status: 404}} ->
        {:error, :canvas_not_found}

      {:ok, %Tesla.Env{status: 422, body: %{"errors" => errors}}} ->
        {:error, errors}

      _error ->
        {:error, :unknown_error}
    end
  end

  @impl CanvasClient.HTTPClientBehaviour
  def fetch_canvas(canvas_id) do
    canvas = %Canvas{
      id: canvas_id,
      rectangles: []
    }

    {:ok, canvas}
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
