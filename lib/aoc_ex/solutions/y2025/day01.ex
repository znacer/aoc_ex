defmodule AocEx.Solutions.Y2025.Day01 do
  alias AocEx.Puzzles

  def part1 do
    puzzle = Puzzles.get_puzzle!(2025, 1).part1
    start = 50

    solution =
      puzzle
      |> String.split("\n", trim: true)
      |> Enum.reduce({start, 0}, fn line, {current_pos, count} ->
        new_pos = Integer.mod(current_pos + parse_line(line), 100)

        new_count = if new_pos == 0, do: count + 1, else: count
        {new_pos, new_count}
      end)
      |> elem(1)

    solution
  end

  def part2 do
    puzzle = Puzzles.get_puzzle!(2025, 1).part1
    start = 50

    puzzle
    |> String.split("\n", trim: true)
    |> Enum.reduce({start, 0}, fn line, {pos, count} ->
      move = parse_line(line)
      new_pos = Integer.mod(pos + move, 100)

      full_laps = div(abs(move), 100)
      remainder = rem(abs(move), 100)

      crossed =
        cond do
          pos == 0 -> 0
          move < 0 -> if remainder >= pos, do: 1, else: 0
          move > 0 -> if remainder >= 100 - pos, do: 1, else: 0
        end

      zeros = full_laps + crossed

      {new_pos, count + zeros}
    end)
    |> elem(1)
  end

  defp parse_line(line) do
    {sign, nb} = String.split_at(line, 1)

    sign =
      case sign do
        "R" -> +1
        _ -> -1
      end

    String.to_integer(nb) * sign
  end
end
