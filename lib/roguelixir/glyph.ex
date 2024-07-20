defmodule Roguelixir.Glyph do
  defstruct [:char, :color, :bg_color]

  import Roguelixir.Colors

  def new(char), do: new(char, c_White(), c_Black())
  def new(char, color), do: new(char, color, c_Black())

  def new(char, color, bg_color) when is_binary(char),
    do: %__MODULE__{char: char, color: color, bg_color: bg_color}
end
