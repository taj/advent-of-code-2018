defmodule AdventOfCode2018.Day03 do
  alias AdventOfCode2018.Day03.Rectangle

  # puzzle answer is 105071
  def part1() do
    claims = read_input()

    {fabric_width, _fabric_height} = claims |> find_fabric_size()

    claims
    |> Enum.map(fn claim ->
      build_coords(claim, fabric_width)
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

  # puzzle answer is 222
  # i know performance it's crap but i'm tired
  def part2() do
    claims = read_input()

    {fabric_width, _fabric_height} = claims |> find_fabric_size()

    claims
    |> Enum.map(fn claim ->
      {claim.id,
       build_coords(claim, fabric_width)
       |> MapSet.new()}
    end)
    |> Enum.map(fn {id, claim} ->
      {id, coords_overlap?(claim, claims, fabric_width)}
    end)
    |> Enum.filter(fn {_, overlapping} -> overlapping == false end)
  end

  defp read_input() do
    {:ok, input} = File.read("./lib/day03/input.txt")

    String.split(input, "\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn x ->
      id =
        Enum.at(x, 0)
        |> String.trim_leading("#")
        |> String.to_integer()

      deltas =
        Enum.at(x, 2)
        |> String.split(",")
        |> Enum.map(&(String.trim_trailing(&1, ":") |> String.to_integer()))

      dimensions =
        Enum.at(x, 3)
        |> String.split("x")
        |> Enum.map(&String.to_integer(&1))

      %Rectangle{
        id: id,
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

  defp build_coords(claim, fabric_width) do
    for i <- 0..(claim.height - 1), j <- 0..(claim.width - 1) do
      j + claim.delta_l + fabric_width * (claim.delta_t + i)
    end
  end

  defp coords_overlap?(claim_to_check, claims, fabric_width) do
    Enum.map(claims, fn claim ->
      claim_coords = build_coords(claim, fabric_width) |> MapSet.new()

      MapSet.intersection(claim_coords, claim_to_check)
      |> Enum.empty?() && !MapSet.equal?(claim_coords, claim_to_check)
    end)
    |> Enum.count(fn intersection -> !intersection end)
    |> case do
      1 ->
        false

      _ ->
        true
    end
  end
end
