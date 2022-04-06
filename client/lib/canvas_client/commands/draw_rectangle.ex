defmodule CanvasClient.Commands.DrawRectangle do
  @moduledoc """
  Sends a draw rectangle request to the server using the attributes
  parsed out from the command-line arguments.
  """

  @command_line_options_config [
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

  def run(args) do
    case parse_rectangle_arguments(args) do
      {:ok, attrs} ->
        draw_rectangle(attrs)

      {:invalid_arguments, invalid_arg_names} ->
        invalid_arg_string = Enum.join(invalid_arg_names, ", ")
        IO.puts("The following argument(s) are missing or invalid: #{invalid_arg_string}.")
    end
  end

  defp parse_rectangle_arguments(args) do
    case OptionParser.parse(args, @command_line_options_config) do
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

  defp draw_rectangle(attrs) do
    case http_client().draw_rectangle(attrs) do
      :ok ->
        IO.puts("Drew a rectangle on the canvas.")

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
