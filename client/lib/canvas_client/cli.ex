defmodule CanvasClient.CLI do
  @moduledoc """
  Module for parsing command-line arguments and dispatching the requests.
  """

  @help_message """
  Usage:
    canvas_client help\tPrints this message.
    canvas_client create\tCreates a new canvas.
  """

  @unknown_command_message "The command you entered is not supported. " <>
                             "Please, run `canvas_client help` " <>
                             "to see the supported commands and arguments."

  def main(["help" | _args]) do
    IO.puts(@help_message)
  end

  def main(["new"]) do
    with {:ok, canvas} <- http_client().create_canvas() do
      IO.puts("Created canvas with id #{canvas.id}.")
    else
      _error -> IO.puts("Failed to create a canvas.")
    end
  end

  def main(_args) do
    IO.puts(@unknown_command_message)
  end

  defp http_client do
    Application.fetch_env!(:canvas_client, :http_client)
  end
end
