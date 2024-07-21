defmodule Roguelixir.Entity do
  use Agent

  defstruct [:id, :pos, :glyph, :block_view]

  alias Roguelixir.Glyph
  alias Roguelixir.Referene

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(reference) do
    Agent.get(__MODULE__, &Map.get(&1, reference))
  end

  def new(
        {_y, _x} = position,
        %Glyph{} = glyph
      ) do
    reference = Referene.new()

    e = %__MODULE__{
      id: reference,
      pos: position,
      glyph: glyph,
      block_view: false
    }

    Agent.update(__MODULE__, &Map.put(&1, reference, e))

    e
  end
end
