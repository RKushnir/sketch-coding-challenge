defmodule CanvasClient.Commands.Help do
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

  def run(_args) do
    IO.puts(@help_message)
  end
end
