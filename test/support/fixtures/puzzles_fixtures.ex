defmodule AocEx.PuzzlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `AocEx.Puzzles` context.
  """

  @doc """
  Generate a puzzle.
  """
  def puzzle_fixture(attrs \\ %{}) do
    {:ok, puzzle} =
      attrs
      |> Enum.into(%{
        day: 42,
        part1: "some part1",
        part2: "some part2",
        title: "some title",
        year: 42
      })
      |> AocEx.Puzzles.create_puzzle()

    puzzle
  end
end
