defmodule CanvasClient.Commands.Help do
  @help_message """
  Usage:
    canvas_client help\tPrints this message.
    canvas_client new\tCreates a new canvas.
    canvas_client draw <canvas_id> <attributes>\tDraws a rectangle on the canvas.
      Where attributes should contain:
        -t, --top\tVertical offset of the top left corner of the rectangle.
        -l, --left\tHorizontal offset of the top left corner of the rectangle.
        -h, --height x\tHeight (required).
        -w, --width x\tWidth (required).
        -f, --fill x\tFill character (required if the outline character is not provided).
        -o, --outline x\tOutline character (required if the fill character is not provided).
    canvas_client render <canvas_id>\tRenders the canvas to the screen.
  """

  def run(_args) do
    IO.write(@help_message)
  end
end
