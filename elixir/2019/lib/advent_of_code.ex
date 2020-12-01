defmodule AdventOfCode do
  @moduledoc """
  Documentation for AdventOfCode.
  """

  def read_puzzle_input(filename, opts \\ []) do
    case File.read(Path.join(["input", filename <> ".txt"])) do
      {:ok, data} -> if opts[:disable_trim], do: data, else: String.trim(data)
      {:error, _} -> nil
    end
  end
end
