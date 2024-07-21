defmodule RoguelixirWeb.GameLive do
  use RoguelixirWeb, :live_view

  alias Roguelixir

  @move_keys [
    "ArrowUp",
    "ArrowDown",
    "ArrowLeft",
    "ArrowRight"
  ]

  def mount(_params, _session, socket) do
    {game_id, grid} = Roguelixir.new_game()

    {:ok, assign(socket, logs: [], grid: generate_grid(grid), game_id: game_id)}
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

  def handle_event("key_pressed", %{"key" => key}, socket) when key in @move_keys do
    direction =
      case key do
        "ArrowUp" -> :up
        "ArrowDown" -> :down
        "ArrowLeft" -> :left
        "ArrowRight" -> :right
      end

    new_grid = Roguelixir.move_player(socket.assigns.game_id, direction)

    {:noreply, assign(socket, grid: generate_grid(new_grid))}
  end

  def handle_event("key_pressed", _, socket) do
    {:noreply, socket}
  end

  defp generate_grid(grid) do
    grid
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
