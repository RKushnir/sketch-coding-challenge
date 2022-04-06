defmodule CanvasClient.HTTPClientBehaviour do
  @callback create_canvas() :: {:ok, map()} | :error
  @callback draw_rectangle(map()) :: :ok | {:error, atom()} | {:error, [{binary(), binary()}]}
  @callback fetch_canvas(binary()) :: {:ok, map()} | {:error, atom()}
end
