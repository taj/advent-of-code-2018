defmodule AdventOfCode2018.Day06 do
  @moduledoc """
  --- Day 6: Chronal Coordinates ---

  The device on your wrist beeps several times, and once again you feel like you're falling.

  "Situation critical," the device announces. "Destination indeterminate. Chronal interference detected. Please specify new target coordinates."

  The device then produces a list of coordinates (your puzzle input). Are they places it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.

  If they're dangerous, maybe you can minimize the danger by finding the coordinate that gives the largest distance from the other points.

  Using only the Manhattan distance, determine the area around each coordinate by counting the number of integer X,Y locations that are closest to that coordinate (and aren't tied in distance to any other coordinate).

  Your goal is to find the size of the largest area that isn't infinite. For example, consider the following list of coordinates:

  1, 1
  1, 6
  8, 3
  3, 4
  5, 5
  8, 9

  If we name these coordinates A through F, we can draw them on a grid, putting 0,0 at the top left:

  ..........
  .A........
  ..........
  ........C.
  ...D......
  .....E....
  .B........
  ..........
  ..........
  ........F.

  This view is partial - the actual grid extends infinitely in all directions. Using the Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:

  aaaaa.cccc
  aAaaa.cccc
  aaaddecccc
  aadddeccCc
  ..dDdeeccc
  bb.deEeecc
  bBb.eeee..
  bbb.eeefff
  bbb.eeffff
  bbb.ffffFf

  Locations shown as . are equally far from two or more coordinates, and so they don't count as being closest to any.

  In this example, the areas of coordinates A, B, C, and F are infinite - while not shown here, their areas extend forever outside the visible grid. However, the areas of coordinates D and E are finite: D is closest to 9 locations, and E is closest to 17 (both including the coordinate's location itself). Therefore, in this example, the size of the largest area is 17.

  What is the size of the largest area that isn't infinite?
  """

  # Couldn't work out how to remove the infinite grids. Leaving like this for now
  # TODO: Remove infinite grids and return single grid area!
  def part1() do
    coords = read_input()
    indexed_coords = coords |> Enum.with_index()

    [grid_x, grid_y] = find_grid_size(coords)

    for x <- 0..grid_x, y <- 0..grid_y do
      all_dists =
        Enum.map(indexed_coords, fn {coord, index} ->
          {index, manhattan_dist(coord, [x, y])}
        end)

      min_dist = Enum.min_by(all_dists, &elem(&1, 1))

      Enum.filter(all_dists, fn dist ->
        elem(dist, 1) == elem(min_dist, 1)
      end)
      |> Enum.count()
      |> case do
        1 ->
          elem(min_dist, 0)

        _ ->
          -1
      end
    end
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Enum.to_list()
    |> Enum.reject(&(elem(&1, 0) == 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sort(&(&1 >= &2))
  end

  defp read_input() do
    {:ok, input} = File.read("./lib/day06/input.txt")

    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.splitter(line, [", "])
      |> Enum.take(2)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp find_grid_size(coords) do
    max_x =
      coords
      |> Enum.max_by(&Enum.at(&1, 0))
      |> Enum.at(0)

    max_y =
      coords
      |> Enum.max_by(&Enum.at(&1, 1))
      |> Enum.at(1)

    [max_x, max_y]
  end

  defp manhattan_dist(a, b) do
    [ax, ay] = a
    [bx, by] = b
    Kernel.abs(ax - bx) + Kernel.abs(ay - by)
  end
end
