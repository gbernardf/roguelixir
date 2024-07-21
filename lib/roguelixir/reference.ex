defmodule Roguelixir.Referene do
  @symbols ~c"0123456789abcdef"

  def new do
    char_list =
      for _ <- 1..8 do
        Enum.random(@symbols)
      end

    to_string(char_list)
  end
end
