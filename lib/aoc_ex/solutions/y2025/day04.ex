defmodule AocEx.Solutions.Y2025.Day04 do
  alias AocEx.Puzzles
  require Logger

  def part1 do
    puzzle =
      puzzle_input().part1
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    neighbor_count(puzzle)
    |> count_movable()
  end

  defp neighbor_count(puzzle) do
    max_col = length(Enum.at(puzzle, 0))
    max_line = length(puzzle)

    puzzle
    |> Stream.with_index()
    |> Enum.map(fn {line, line_nb} ->
      line
      |> Stream.with_index()
      |> Enum.map(fn {elt, col_nb} ->
        if elt == "@" do
          Enum.reduce(
            (line_nb - 1)..(line_nb + 1),
            0,
            fn i, i_acc ->
              if i < 0 or i >= max_line do
                i_acc
              else
                col_sum =
                  Enum.reduce((col_nb - 1)..(col_nb + 1), 0, fn j, acc ->
                    if j < max_col and j >= 0 and
                         (j != col_nb or i != line_nb) do
                      char =
                        puzzle
                        |> Enum.at(i)
                        |> Enum.at(j)

                      if char == "@" do
                        acc + 1
                      else
                        acc
                      end
                    else
                      acc
                    end
                  end)

                i_acc + col_sum
              end
            end
          )
        else
          "."
        end
      end)
    end)
  end

  defp count_movable(counted_puzzle) do
    counted_puzzle
    |> List.flatten()
    |> Enum.filter(fn x -> x != "." and x < 4 end)
    |> length()
  end

  defp move_rolls(counted_puzzle) do
    counted_puzzle
    |> Enum.map(fn line ->
      line
      |> Enum.map(fn x ->
        if x == "." or x < 4 do
          "."
        else
          "@"
        end
      end)
    end)
  end

  defp loop_move_roll(counted_puzzle) do
    if count_movable(counted_puzzle) == 0 do
      counted_puzzle
    else
      counted_puzzle
      |> move_rolls()
      |> neighbor_count()
      |> loop_move_roll()
    end
  end

  def part2 do
    puzzle =
      puzzle_input().part2
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    counted_puzzle = neighbor_count(puzzle)

    unmovables =
      loop_move_roll(counted_puzzle)
      |> List.flatten()
      |> Enum.filter(fn x -> x != "." end)
      |> length()

    total_rolls =
      puzzle
      |> List.flatten()
      |> Enum.filter(fn x -> x != "." end)
      |> length()

    total_rolls - unmovables
  end

  defp puzzle_input do
    Puzzles.get_puzzle!(2025, 4)
  end
end
