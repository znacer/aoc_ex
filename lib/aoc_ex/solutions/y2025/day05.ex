defmodule AocEx.Solutions.Y2025.Day05 do
  alias AocEx.Puzzles
  require Logger

  def part1 do
    puzzle =
      puzzle_input().part1
      |> parse_puzzle_input()

    [fresh_ranges, available_ids] = puzzle

    available_ids
    |> Enum.map(fn x ->
      fresh_ranges
      |> Enum.map(fn {l, r} -> x >= l and x <= r end)
      |> Enum.any?()
    end)
    |> Enum.count(& &1)
  end

  def part2 do
    puzzle =
      puzzle_input().part2
      |> parse_puzzle_input()

    [fresh_ranges, _] = puzzle

    fresh_ranges
    |> Enum.sort()
    |> merge_ranges()
    |> Enum.map(fn {l, r} ->
      1 + r - l
    end)
    |> Enum.sum()
  end

  def merge_ranges(ranges) do
    [first | rest] = ranges

    rest
    |> Enum.reduce([first], fn {start, stop}, acc ->
      [{merged_start, merged_stop} | tail] = acc

      if start <= merged_stop + 1 do
        [{merged_start, max(merged_stop, stop)} | tail]
      else
        [{start, stop} | acc]
      end
    end)
  end

  defp puzzle_input do
    Puzzles.get_puzzle!(2025, 5)
  end

  defp parse_puzzle_input(raw_puzzle) do
    puzzle =
      raw_puzzle
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))

    [fresh_ranges, available_ids] = puzzle

    fresh_ranges =
      fresh_ranges
      |> Enum.map(fn range ->
        [l, r] = range |> String.split("-") |> Enum.map(&String.to_integer/1)
        {l, r}
      end)

    available_ids = available_ids |> Enum.map(&String.to_integer/1)
    [fresh_ranges, available_ids]
  end
end
