defmodule Roguelixir.Entity do
  defstruct [:pos, :glyph]

  alias Roguelixir.Glyph

  def new(
        {_y, _x} = position,
        %Glyph{} = glyph
      ) do
    %__MODULE__{
      pos: position,
      glyph: glyph
    }
  end
end
