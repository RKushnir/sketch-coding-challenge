defmodule CanvasClient.Commands.RenderCanvas do
  @moduledoc """
  Fetches the canvas from the server and renders it to the screen.
  """

  def run([canvas_id]) do
    case http_client().fetch_canvas(canvas_id) do
      {:ok, _canvas} ->
        IO.puts("Canvas rendered.")

      {:error, :canvas_not_found} ->
        IO.puts("There is no canvas with the given id.")
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
