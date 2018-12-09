defmodule AdventOfCode2018.Day05 do
  @moduledoc """
  --- Day 5: Alchemical Reduction ---

  You've managed to sneak in to the prototype suit manufacturing lab. The Elves are making decent progress, but are still struggling with the suit's size reduction capabilities.

  While the very latest in 1518 alchemical technology might have solved their problem eventually, you can do better. You scan the chemical composition of the suit's material and discover that it is formed by extremely long polymers (one of which is available as your puzzle input).

  The polymer is formed by smaller units which, when triggered, react with each other such that two adjacent units of the same type and opposite polarity are destroyed. Units' types are represented by letters; units' polarity is represented by capitalization. For instance, r and R are units with the same type but opposite polarity, whereas r and s are entirely different types and do not react.

  For example:

    In aA, a and A react, leaving nothing behind.
    In abBA, bB destroys itself, leaving aA. As above, this then destroys itself, leaving nothing.
    In abAB, no two adjacent units are of the same type, and so nothing happens.
    In aabAAB, even though aa and AA are of the same type, their polarities match, and so nothing happens.

  Now, consider a larger example, dabAcCaCBAcCcaDA:

  dabAcCaCBAcCcaDA  The first 'cC' is removed.
  dabAaCBAcCcaDA    This creates 'Aa', which is removed.
  dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
  dabCBAcaDA        No further actions can be taken.

  After all possible reactions, the resulting polymer contains 10 units.

  How many units remain after fully reacting the polymer you scanned? (Note: in this puzzle and others, the input is large; if you copy/paste your input, make sure you get the whole thing.)
  """

  # puzzle answer is 9238
  def part1 do
    read_input()
    |> String.graphemes()
    |> polymer_after_reaction()
    |> length
  end

  defp read_input() do
    {:ok, input} = File.read("./lib/day05/input.txt")

    input
  end

  defp polymer_after_reaction(polymer) do
    polymer
    |> Enum.reduce([], fn x, acc ->
      case acc do
        [] ->
          [x]

        [head | tail] = all ->
          if x != head && String.downcase(x) == String.downcase(head) do
            tail
          else
            [x | all]
          end

        list ->
          [x | list]
      end
    end)
  end
end
