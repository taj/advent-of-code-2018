defmodule AdventOfCode2018.Day01 do
  def part1() do
    input = read_file()

    Enum.reduce(input, 0, fn x, acc -> x + acc end)
  end

  defp read_file() do
    {:ok, input} = File.read("./lib/day01/input.txt")

    String.split(input, "\n") |> Enum.map(&String.to_integer/1)
  end
end
