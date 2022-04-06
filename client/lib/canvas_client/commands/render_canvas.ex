defmodule CanvasClient.Commands.RenderCanvas do
  @moduledoc """
  Fetches the canvas from the server and renders it to the screen.
  """
  alias CanvasClient.Renderer

  # The size of the canvas is static, if I understood the requirements correctly.
  # Alternatively, we could put the size in the configuration,
  # or receive from the server for maximum flexibility.
  @canvas_width 80
  @canvas_height 30

  def run([canvas_id]) do
    case http_client().fetch_canvas(canvas_id) do
      {:ok, canvas} ->
        render_canvas(canvas)

      {:error, :canvas_not_found} ->
        IO.puts("There is no canvas with the given id.")
    end
  end

  def run(args) do
    args_string = Enum.join(args, ", ")

    IO.write("""
    Received odd arguments: #{args_string}.
    Please, use `canvas_client help` to see usage instructions.
    """)
  end

  defp render_canvas(canvas) do
    rendering_canvas = Renderer.new_canvas(@canvas_width, @canvas_height)

    rendering_canvas =
      Enum.reduce(
        canvas.rectangles,
        rendering_canvas,
        &Renderer.render_rectangle(&2, &1)
      )

    IO.write("\r")
    IO.puts(Renderer.to_string(rendering_canvas))
  end

  defp http_client do
    Application.fetch_env!(:canvas_client, :http_client)
  end
end
