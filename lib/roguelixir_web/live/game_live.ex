defmodule RoguelixirWeb.GameLive do
  use RoguelixirWeb, :live_view

  @max_width 79
  @max_height 49
  def mount(_params, _session, socket) do
    player = {12, 12}
    {:ok, assign(socket, logs: [], grid: generate_grid(player), player: player)}
  end

  def render(assigns) do
    ~H"""
    <div class="container" phx-window-keyup="key_up">
      <div class="grid">
        <%= for {row, row_idx} <- Enum.with_index(@grid), {cell, cell_idx} <- Enum.with_index(row) do %>
          <div
            class={"cell #{if {row_idx, cell_idx} == @player, do: "player", else: ""}"}
            id={"cell-#{row_idx}-#{cell_idx}"}
          >
            <%= cell %>
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

  def handle_event("key_up", %{"key" => key}, socket) do
    {y, x} = socket.assigns.player

    new_player =
      case key do
        "ArrowUp" -> {max(y - 1, 0), x}
        "ArrowDown" -> {min(y + 1, @max_height), x}
        "ArrowLeft" -> {y, max(x - 1, 0)}
        "ArrowRight" -> {y, min(x + 1, @max_width)}
      end

    {:noreply, assign(socket, grid: generate_grid(new_player), player: new_player)}
  end

  defp generate_grid(player) do
    for y <- 0..@max_height do
      for x <- 0..@max_width do
        case {y, x} do
          ^player -> "@"
          {0, _} -> "#"
          {_, 0} -> "#"
          {@max_height, _} -> "#"
          {_, @max_width} -> "#"
          _ -> "."
        end
      end
    end
  end
end
