defmodule GuessingGame do
  def guess(low, high) do
    answer = IO.gets("Hmm... maybe you're thinking of #{mid(low, high)}?\n")

    case String.trim(answer) do
      "bigger" ->
        new_low = new_low(low, high)
        guess(new_low, high)

      "smaller" ->
        new_high = new_high(low, high)
        guess(low, new_high)

      "yes" ->
        "I knew I could guess your number!"

      _ ->
        IO.puts(~s{Type "bigger", "smaller", or "yes"})
        guess(low, high)
    end
  end

  def mid(low, high) do
    div(low + high, 2)
  end

  def new_low(low, high) do
    min(high, mid(low, high) + 1)
  end

  def new_high(low, high) do
    max(low, mid(low, high) - 1)
  end
end
