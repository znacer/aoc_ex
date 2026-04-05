defmodule AocEx.Solutions.Y2025.Day03 do
  alias AocEx.Puzzles
  require Logger

  def part1 do
    puzzle = puzzle_input().part1

    puzzle
    |> parse_puzzle()
    |> Enum.map(fn line ->
      # for each line find the max except last element
      max = Enum.max(Enum.drop(line, -1))
      # get the max element id
      max_id = Enum.find_index(line, &(&1 == max))
      # find the max2 element between the max and the last element
      max2 = Enum.max(Enum.drop(line, max_id + 1))
      # max2_id = Enum.find_index(line, &(&1 == max2))
      10 * max + max2
    end)
    |> Enum.sum()
  end

  defp parse_puzzle(puzzle) do
    puzzle
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.graphemes(line)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part2 do
    puzzle = puzzle_input().part2

    puzzle
    |> parse_puzzle()
    |> Enum.map(fn line ->
      select_max_digits(line, 12)
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  defp select_max_digits(digits, k) do
    n = length(digits)
    do_select_max(digits, k, 0, n, [])
  end

  defp do_select_max(_digits, 0, _start, _n, acc), do: Enum.reverse(acc)

  defp do_select_max(digits, k, start, n, acc) do
    # We need to pick k more digits starting from index `start`
    # The last possible index we can pick from is n - k
    last_possible = n - k

    # Find the maximum digit and its index in the valid range
    {max_val, max_idx} =
      digits
      |> Enum.with_index()
      |> Enum.slice(start..last_possible//1)
      |> Enum.max_by(fn {val, _idx} -> val end)

    # Continue from after max_idx
    do_select_max(digits, k - 1, max_idx + 1, n, [max_val | acc])
  end

  defp puzzle_input do
    Puzzles.get_puzzle!(2025, 3)
  end
end
