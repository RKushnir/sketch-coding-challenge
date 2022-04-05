defmodule CanvasClient.CLITest do
  use ExUnit.Case
  alias CanvasClient.CLI
  import ExUnit.CaptureIO
  import Tesla.Mock

  test "prints an error message for unsupported commands" do
    assert capture_io(fn -> CLI.main(["unknown", "-c", "ommand"]) end) =~ ~r/not supported/
  end

  test "prints the help message for the help command" do
    assert capture_io(fn -> CLI.main(["help", "whatever"]) end) =~ ~r/Usage/
  end

  test "creates a new canvas for the new command" do
    mock(fn
      %{method: :post, url: "http://localhost:4000/canvases"} ->
        json(%{id: "8c375cd2-eeaa-42b7-9295-c790129a6598"})
    end)

    assert capture_io(fn -> CLI.main(["new"]) end) =~
             ~r/Created canvas with id 8c375cd2-eeaa-42b7-9295-c790129a6598/
  end
end
