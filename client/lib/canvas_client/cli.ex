defmodule CanvasClient.CLI do
  @moduledoc """
  Dispatches the requests to the appropriate handlers.
  """

  alias CanvasClient.Commands

  @unknown_command_message "The command you entered is not supported. " <>
                             "Please, run `canvas_client help` " <>
                             "to see the supported commands and arguments."

  def main(["help" | args]) do
    Commands.Help.run(args)
  end

  def main(["new" | args]) do
    Commands.CreateCanvas.run(args)
  end

  def main(["draw" | args]) do
    Commands.DrawRectangle.run(args)
  end

  def main(_args) do
    IO.puts(@unknown_command_message)
  end
end
