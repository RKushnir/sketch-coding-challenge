import Config

config :canvas_client, http_client: CanvasClient.HTTPClient

if Mix.env() == :test do
  config :tesla, adapter: Tesla.Mock
  config :canvas_client, http_client: CanvasClient.HTTPClientMock
end
