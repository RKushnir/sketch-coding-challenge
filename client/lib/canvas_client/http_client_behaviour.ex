defmodule CanvasClient.HTTPClientBehaviour do
  @callback create_canvas() :: {:ok, map()} | :error
end
