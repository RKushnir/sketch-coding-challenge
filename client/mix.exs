defmodule CanvasClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :canvas_client,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: CanvasClient.CLI]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:jason, ">= 1.0.0"},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
