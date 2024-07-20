defmodule Roguelixir do
  alias Roguelixir.Entity
  alias Roguelixir.Glyph

  import Roguelixir.Colors

  @max_width 79
  @max_height 49

  def new_game do
    player_glyph = Glyph.new("@", c_Yellow())
    player = Entity.new({12, 12}, player_glyph)
    grid = build_grid(player)

    %{player: player, grid: grid}
  end

  def build_grid(player) do
    0..@max_height
    |> Enum.reduce(%{}, fn y, acc ->
      0..@max_width
      |> Enum.reduce(acc, fn x, grid -> Map.put(grid, {y, x}, glyph_from_pos({y, x}, player)) end)
    end)
  end

  def move_player(%{player: player} = game, direction) do
    {y, x} = game.player.pos

    new_pos =
      case direction do
        :up -> {max(y - 1, 0), x}
        :down -> {min(y + 1, @max_height), x}
        :left -> {y, max(x - 1, 0)}
        :right -> {y, min(x + 1, @max_width)}
        _ -> {y, x}
      end

    new_player = %{player | pos: new_pos}

    new_grid =
      game.grid
      |> Map.put({y, x}, Glyph.new("."))
      |> Map.put(new_pos, new_player.glyph)

    %{game | player: new_player, grid: new_grid}
  end

  defp glyph_from_pos(pos, %{pos: p, glyph: g} = _player) do
    wall = Glyph.new("#")
    ground = Glyph.new(".")

    case pos do
      ^p -> g
      {0, _} -> wall
      {_, 0} -> wall
      {@max_height, _} -> wall
      {_, @max_width} -> wall
      _ -> ground
    end
  end
end
