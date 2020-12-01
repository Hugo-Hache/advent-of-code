defmodule AdventOfCode.Day16 do
  def part1(input, phases \\ 100) do
    signal = input
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)

    (1..phases)
    |> Enum.reduce(signal, fn _, signal ->
      signal |> fft
    end)
    |> Enum.take(8)
    |> Enum.join("")
  end

  def part2(input, phases \\ 100) do
    signal = input
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
    offset = signal |> Enum.take(7) |> Integer.undigits
    real_signal = List.duplicate(signal, 10000) |> List.flatten |> Enum.drop(offset)

    (1..phases)
    |> Enum.reduce(real_signal, fn _, signal ->
      signal |> special_fft
    end)
    |> Enum.take(8)
    |> Enum.join("")
  end

  def special_fft(signal) do
    signal
    |> Enum.reverse
    |> Enum.reduce({[], 0}, fn i, {new_signal, last_digit} ->
      new_digit = (last_digit + i)
      |> abs
      |> Integer.digits
      |> List.last
      {[new_digit | new_signal], last_digit + i}
    end)
    |> elem(0)
  end

  def fft(signal, pattern \\ [0, 1, 0, -1]) do
    (1..length(signal))
    |> Enum.map(fn i ->
      positional_pattern = pattern
                       |> Enum.map(&(List.duplicate(&1, i)))
                       |> List.flatten
                       |> Stream.cycle
                       |> Stream.drop(1)

      signal
      |> Enum.zip(positional_pattern)
      |> Enum.reduce(0, fn {s, p}, acc ->
        acc + (s * p)
      end)
      |> abs
      |> Integer.digits
      |> List.last
    end)
  end
end
