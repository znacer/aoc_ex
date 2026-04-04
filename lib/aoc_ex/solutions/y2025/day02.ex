defmodule AocEx.Solutions.Y2025.Day02 do
  alias AocEx.Puzzles

  def part1 do
    puzzle = Puzzles.get_puzzle!(2025, 2).part1

    puzzle
    |> String.split(",")
    |> Enum.map(&parse_range/1)
    |> Enum.map(&sum_repeating_in_range/1)
    |> Enum.sum()
  end

  def part2 do
    puzzle = Puzzles.get_puzzle!(2025, 2).part1

    puzzle
    |> String.split(",")
    |> Enum.map(&parse_range/1)
    |> Enum.map(&sum_repeating_in_range_sequence/1)
    |> Enum.sum()
  end

  defp parse_range(idrange) do
    [id0, id1] =
      idrange
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    id0..id1
  end

  defp sum_repeating_in_range(range) do
    range
    |> Enum.filter(&repeating_digits?/1)
    |> Enum.sum()
  end

  defp repeating_digits?(id) when id <= 10, do: false

  defp repeating_digits?(id) do
    digits = Integer.digits(id)
    len = length(digits)

    if rem(len, 2) == 0 do
      half = div(len, 2)
      left = digits |> Enum.take(half)
      right = digits |> Enum.drop(half)
      left == right
    else
      false
    end
  end

  defp sum_repeating_in_range_sequence(range) do
    range
    |> Enum.filter(&repeating_sequence?/1)
    |> Enum.sum()
  end

  defp repeating_sequence?(id) when id <= 10, do: false

  defp repeating_sequence?(id) do
    digits = Integer.digits(id)
    len = length(digits)

    Enum.any?(1..div(len, 2), fn unit_len ->
      if rem(len, unit_len) == 0 do
        unit = Enum.take(digits, unit_len)
        repetitions = div(len, unit_len)

        List.duplicate(unit, repetitions) |> List.flatten() == digits
      else
        false
      end
    end)
  end
end
