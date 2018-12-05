defmodule AdventOfCode2018.Day03 do
  alias AdventOfCode2018.Day03.Rectangle

  def part1() do
    claims = read_input()

    {fabric_width, _fabric_height} = claims |> find_fabric_size()

    claims
    |> Enum.map(fn claim ->
      for i <- 0..(claim.height - 1), j <- 0..(claim.width - 1) do
        j + claim.delta_l + fabric_width * (claim.delta_t + i)
      end
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Enum.reduce(0, fn {_, count}, acc ->
      if count > 1 do
        acc + 1
      else
        acc
      end
    end)
  end

  defp read_input() do
    {:ok, input} = File.read("./lib/day03/input.txt")

    String.split(input, "\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn x ->
      deltas =
        Enum.at(x, 2)
        |> String.split(",")
        |> Enum.map(&(String.trim_trailing(&1, ":") |> String.to_integer()))

      dimensions =
        Enum.at(x, 3)
        |> String.split("x")
        |> Enum.map(&String.to_integer(&1))

      %Rectangle{
        delta_l: Enum.at(deltas, 0),
        delta_t: Enum.at(deltas, 1),
        width: Enum.at(dimensions, 0),
        height: Enum.at(dimensions, 1)
      }
    end)
  end

  defp find_fabric_size(claims) do
    max_delta_l =
      claims
      |> Enum.map(fn x -> x.delta_l end)
      |> Enum.max()

    max_delta_t =
      claims
      |> Enum.map(fn x -> x.delta_t end)
      |> Enum.max()

    max_delta_width =
      claims
      |> Enum.map(fn x -> x.width end)
      |> Enum.max()

    max_delta_height =
      claims
      |> Enum.map(fn x -> x.height end)
      |> Enum.max()

    {max_delta_l + max_delta_width, max_delta_t + max_delta_height}
  end
end
