defmodule CanvasClient.CLI do
  @moduledoc """
  Module for parsing command-line arguments and dispatching the requests.
  """

  @help_message """
  Usage:
    canvas_client help\tPrints this message.
  """

  @unknown_command_message "The command you entered is not supported. " <>
                             "Please, run `canvas_client help` " <>
                             "to see the supported commands and arguments."

  def main(["help" | _args]) do
    IO.puts(@help_message)
  end

  def main(_args) do
    IO.puts(@unknown_command_message)
  end
end
