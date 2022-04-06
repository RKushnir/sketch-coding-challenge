defmodule CanvasClient.CLI do
  @moduledoc """
  Module for parsing command-line arguments and dispatching the requests.
  """

  @help_message """
  Usage:
    canvas_client help\tPrints this message.
    canvas_client create\tCreates a new canvas.
    canvas_client draw <canvas_id> <attributes>\tDraws a rectangle on the canvas.
      Where attributes should contain:
        -x, --top\tVertical offset of the top left corner of the rectangle.
        -y, --left\tHorizontal offset of the top left corner of the rectangle.
        -h, --height x\tHeight (required).
        -w, --width x\tWidth (required).
        -f, --fill x\tFill character (required if the outline character is not provided).
        -o, --outline x\tOutline character (required if the fill character is not provided).
  """

  @unknown_command_message "The command you entered is not supported. " <>
                             "Please, run `canvas_client help` " <>
                             "to see the supported commands and arguments."

  def main(["help" | _args]) do
    IO.puts(@help_message)
  end

  def main(["new"]) do
    with {:ok, canvas} <- http_client().create_canvas() do
      IO.puts("Created a canvas with id #{canvas.id}.")
    else
      _error -> IO.puts("Failed to create a canvas.")
    end
  end

  def main(["draw" | args]) do
    case parse_rectangle_arguments(args) do
      {:ok, attrs} ->
        with :ok <- http_client().draw_rectangle(attrs) do
          IO.puts("Drew a rectangle on the canvas.")
        else
          {:error, :canvas_not_found} ->
            IO.puts("There is no canvas with the given id.")

          {:error, :unknown_error} ->
            IO.puts("Unexpected error happened when contacting the server.")

          {:error, errors} ->
            IO.puts("Couldn't draw a rectangle because of the following error(s):")
            print_errors(errors)

          _error ->
            IO.puts("Failed to draw a rectangle.")
        end

      {:invalid_arguments, invalid_arg_names} ->
        invalid_arg_string = Enum.join(invalid_arg_names, ", ")
        IO.puts("The following argument(s) are missing or invalid: #{invalid_arg_string}.")
    end
  end

  def main(_args) do
    IO.puts(@unknown_command_message)
  end

  defp parse_rectangle_arguments(args) do
    options = [
      strict: [
        top: :integer,
        left: :integer,
        height: :integer,
        width: :integer,
        fill: :string,
        outline: :string
      ],
      aliases: [
        t: :top,
        l: :left,
        h: :height,
        w: :width,
        f: :fill,
        o: :outline
      ]
    ]

    case OptionParser.parse(args, options) do
      {opts, [canvas_id], []} ->
        rectangle_attrs = %{
          canvas_id: canvas_id,
          offset_top: opts[:top],
          offset_left: opts[:left],
          height: opts[:height],
          width: opts[:width],
          fill_character: opts[:fill],
          outline_character: opts[:outline]
        }

        {:ok, rectangle_attrs}

      {_opts, [], []} ->
        {:invalid_arguments, ["canvas_id"]}

      {_, _, invalid_args} ->
        invalid_arg_names = for {name, _value} <- invalid_args, do: name
        {:invalid_arguments, invalid_arg_names}
    end
  end

  defp print_errors(errors) do
    Enum.each(errors, fn {attr_name, error_messages} ->
      Enum.each(error_messages, fn error_message ->
        IO.puts("- #{attr_name}: #{error_message}")
      end)
    end)
  end

  defp http_client do
    Application.fetch_env!(:canvas_client, :http_client)
  end
end
