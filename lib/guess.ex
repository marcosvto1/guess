defmodule Guess do
  use Application
  def run do
    IO.puts("Let's play gues the Number")

    IO.gets("Pick a diffcult level (1,2 or 3):")
    |> parse_input()
    |> pickup_number()
    |> play()

    {:ok, self()}
  end

  def play(picked_num) do
    IO.gets("I Have my Number. What is your guess:")
    |> parse_input()
    |> guess(picked_num, 1)
  end

  def guess(user_guess, picked_num, count) when user_guess > picked_num do
    IO.gets("Too High. Guess again: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(user_guess, picked_num, count) when user_guess < picked_num do
    IO.gets("Too low. Guess again: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(_user_guess, _picked_num, count) do
    IO.puts("You got it #{count} ")
    show_score(count)
  end

  def show_score(guesses) when guesses > 6 do
    IO.puts("Better luck next time")
  end

  def show_score(guesses) do
    {_, msg} = %{1..1 => "You're a mind rider!",
      2..4 => "Most impressive ",
      5..6 => "You can do better than that"
    }
    |> Enum.find(fn {range, _} ->
      Enum.member?(range, guesses)
    end)

    IO.puts(msg)
  end

  def pickup_number(level) do
    level
    |> get_range()
    |> Enum.random()
  end

  @spec parse_input(:error | binary | {any, any}) :: any
  def parse_input(:error) do
    IO.puts("Invalid Level !!")
    run()
  end

  def parse_input({num, _}), do: num

  def parse_input(data) do
    data
    |> Integer.parse()
    |> parse_input()
  end

  def get_range(level) do
    case level do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts("Invalid Level")
        run()
    end
  end


  @spec start(any, any) :: {:ok, pid}
  def start(_,_) do
    run()
  end
end
