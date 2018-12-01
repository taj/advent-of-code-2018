defmodule AdventOfCode2018.Day01 do
  def part1() do
    input = read_file()

    Enum.reduce(input, 0, fn x, acc -> x + acc end)
  end

  def part2() do
    input = read_file()

    find_duplicate(input)
  end

  defp read_file() do
    {:ok, input} = File.read("./lib/day01/input.txt")

    String.split(input, "\n") |> Enum.map(&String.to_integer/1)
  end

  defp find_duplicate(input, starter \\ [], i \\ 0) do
    Enum.reduce_while(input, starter, fn x, acc ->
      case Enum.count acc do
        0 ->
          {:cont, [x]}

        _ ->
          possible_dub = Enum.at(acc, -1) + x

          if Enum.member?(acc, possible_dub) do
            {:halt, possible_dub}
          else
            {:cont, acc ++ [possible_dub]}
          end
      end
    end)
    |> case do
      duplicate when is_integer(duplicate) ->
        duplicate

      list when is_list(list) ->
        IO.inspect("iteration n: #{i}")
        find_duplicate(input, list, i+1)
    end
  end
end
