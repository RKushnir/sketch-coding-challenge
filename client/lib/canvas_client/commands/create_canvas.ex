defmodule CanvasClient.Commands.CreateCanvas do
  @moduledoc """
  Sends a create canvas request to the server.
  """

  def run([]) do
    with {:ok, canvas} <- http_client().create_canvas() do
      IO.puts("Created a canvas with id #{canvas.id}.")
    else
      _error -> IO.puts("Failed to create a canvas.")
    end
  end

  def run(args) do
    args_string = Enum.join(args, ", ")

    IO.write("""
    Received odd arguments: #{args_string}.
    Please, use `canvas_client help` to see usage instructions.
    """)
  end

  defp http_client do
    Application.fetch_env!(:canvas_client, :http_client)
  end
end
