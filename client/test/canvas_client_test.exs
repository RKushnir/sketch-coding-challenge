defmodule CanvasClientTest do
  use ExUnit.Case
  doctest CanvasClient

  test "greets the world" do
    assert CanvasClient.hello() == :world
  end
end
