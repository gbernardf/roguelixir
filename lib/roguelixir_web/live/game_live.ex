defmodule RoguelixirWeb.GameLive do
  use RoguelixirWeb, :live_view

  alias Roguelixir

  def mount(_params, _session, socket) do
    game = Roguelixir.new_game()
    {:ok, assign(socket, logs: [], grid: generate_grid(game), game: game, player: game.player)}
  end

  def render(assigns) do
    ~H"""
    <div class="container" phx-window-keydown="key_pressed" phx-throttle="50">
      <div class="grid">
        <%= for {{y, x}, char, c, bg} <- @grid do %>
          <div class={"cell #{c} #{bg}"} id={"cell-#{y}-#{x}"}>
            <%= char %>
          </div>
        <% end %>
      </div>
      <div class="log-area">
        <h3>Logs:</h3>
        <div>
          <%= for log <- @logs do %>
            <p><%= log %></p>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("key_pressed", %{"key" => key}, socket) do
    game = socket.assigns.game

    new_game =
      case key do
        "ArrowUp" -> Roguelixir.move_player(game, :up)
        "ArrowDown" -> Roguelixir.move_player(game, :down)
        "ArrowLeft" -> Roguelixir.move_player(game, :left)
        "ArrowRight" -> Roguelixir.move_player(game, :right)
        _ -> game
      end

    {:noreply,
     assign(socket, grid: generate_grid(new_game), game: new_game, player: new_game.player)}
  end

  defp generate_grid(game) do
    game.grid
    |> Enum.sort()
    |> Enum.map(&to_cell_tuple/1)
  end

  defp to_cell_tuple({pos, glyph}) do
    {pos, glyph.char, to_css_color(glyph.color), to_css_bg_color(glyph.bg_color)}
  end

  defp to_css_color(color) do
    "c_#{hex_color(color)}"
  end

  defp to_css_bg_color(color) do
    "bg_#{hex_color(color)}"
  end

  defp hex_color(hex) do
    case hex do
      "FFFFFF" -> "white"
      "#000000" -> "black"
      "#FFFF00" -> "yellow"
    end
  end
end
