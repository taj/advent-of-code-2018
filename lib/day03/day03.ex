defmodule AdventOfCode2018.Day03 do
  @moduledoc """
  --- Day 3: No Matter How You Slice It ---

  The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to someone who helpfully wrote its box IDs on the wall of the warehouse in the middle of the night). Unfortunately, anomalies are still affecting them - nobody can even agree on how to cut the fabric.

  The whole piece of fabric they're working on is a very large square - at least 1000 inches on each side.

  Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle is defined as follows:

      The number of inches between the left edge of the fabric and the left edge of the rectangle.
      The number of inches between the top edge of the fabric and the top edge of the rectangle.
      The width of the rectangle in inches.
      The height of the rectangle in inches.

  A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:

  ...........
  ...........
  ...#####...
  ...#####...
  ...#####...
  ...#####...
  ...........
  ...........
  ...........

  The problem is that many of the claims overlap, causing two or more claims to cover part of the same areas. For example, consider the following claims:

  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2

  Visually, these claim the following areas:

  ........
  ...2222.
  ...2222.
  .11XX22.
  .11XX22.
  .111133.
  .111133.
  ........

  The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to the others, does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have enough fabric. How many square inches of fabric are within two or more claims?


  --- Part Two ---

  Amidst the chaos, you notice that exactly one claim doesn't overlap by even a single square inch of fabric with any other claim. If you can somehow draw attention to it, maybe the Elves will be able to make Santa's suit after all!

  For example, in the claims above, only claim 3 is intact after all claims are made.

  What is the ID of the only claim that doesn't overlap?
  """
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
