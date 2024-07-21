defmodule Roguelixir do
  alias Roguelixir.Game

  def new_game do
    {:ok, game_id} = Game.new()
    grid = Game.grid(game_id)

    {game_id, grid}
  end

  def move_player(game_id, direction) do
    Game.move_player(game_id, direction)
  end
end
