defmodule GuessingGameTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest GuessingGame

  test "mid() should return middle value" do
    assert GuessingGame.mid(0, 2) == 1
    assert GuessingGame.mid(1, 10) == 5
  end

  test "new_low() should return middle + 1" do
    assert GuessingGame.new_low(0, 10) == 6
  end

  test "new_low() should return itself" do
    assert GuessingGame.new_low(3, 3) == 3
  end

  test "new_high() should return middle - 1" do
    assert GuessingGame.new_high(0, 10) == 4
  end

  test "new_high() should return itself" do
    assert GuessingGame.new_high(5, 5) == 5
  end

  test "GuessingGame should be playable on happy path" do
    assert capture_io("yes", fn ->
      IO.write GuessingGame.guess(0, 10)
    end) == "Hmm... maybe you're thinking of 5?\nI knew I could guess your number!"
  end
end
