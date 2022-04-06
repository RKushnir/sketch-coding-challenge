defmodule CanvasClient.Commands.CreateCanvas do
  @moduledoc """
  Sends a create canvas request to the server.
  """

  def run(_args) do
    with {:ok, canvas} <- http_client().create_canvas() do
      IO.puts("Created a canvas with id #{canvas.id}.")
    else
      _error -> IO.puts("Failed to create a canvas.")
    end
  end

  defp http_client do
    Application.fetch_env!(:canvas_client, :http_client)
  end
end
