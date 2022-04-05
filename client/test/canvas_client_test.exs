defmodule CanvasClient.CLITest do
  use ExUnit.Case
  alias CanvasClient.CLI
  import ExUnit.CaptureIO

  test "prints an error message for unsupported commands" do
    assert capture_io(fn -> CLI.main(["unknown", "-c", "ommand"]) end) =~ ~r/not supported/
  end

  test "prints the help message for the help command" do
    assert capture_io(fn -> CLI.main(["help", "whatever"]) end) =~ ~r/Usage/
  end

  test "creates a new canvas for the new command" do
    assert capture_io(fn -> CLI.main(["new"]) end) =~ ~r/Created canvas/
  end
end
