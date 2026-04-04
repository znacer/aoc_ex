defmodule AocEx.PuzzlesTest do
  use AocEx.DataCase

  alias AocEx.Puzzles

  describe "puzzles" do
    alias AocEx.Puzzles.Puzzle

    import AocEx.PuzzlesFixtures

    @invalid_attrs %{title: nil, day: nil, year: nil, part1: nil, part2: nil}

    test "list_puzzles/0 returns all puzzles" do
      puzzle = puzzle_fixture()
      assert Puzzles.list_puzzles() == [puzzle]
    end

    test "get_puzzle!/1 returns the puzzle with given id" do
      puzzle = puzzle_fixture()
      assert Puzzles.get_puzzle!(puzzle.id) == puzzle
    end

    test "create_puzzle/1 with valid data creates a puzzle" do
      valid_attrs = %{
        title: "some title",
        day: 42,
        year: 42,
        part1: "some part1",
        part2: "some part2"
      }

      assert {:ok, %Puzzle{} = puzzle} = Puzzles.create_puzzle(valid_attrs)
      assert puzzle.title == "some title"
      assert puzzle.day == 42
      assert puzzle.year == 42
      assert puzzle.part1 == "some part1"
      assert puzzle.part2 == "some part2"
    end

    test "create_puzzle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Puzzles.create_puzzle(@invalid_attrs)
    end

    test "update_puzzle/2 with valid data updates the puzzle" do
      puzzle = puzzle_fixture()

      update_attrs = %{
        title: "some updated title",
        day: 43,
        year: 43,
        part1: "some updated part1",
        part2: "some updated part2"
      }

      assert {:ok, %Puzzle{} = puzzle} = Puzzles.update_puzzle(puzzle, update_attrs)
      assert puzzle.title == "some updated title"
      assert puzzle.day == 43
      assert puzzle.year == 43
      assert puzzle.part1 == "some updated part1"
      assert puzzle.part2 == "some updated part2"
    end

    test "update_puzzle/2 with invalid data returns error changeset" do
      puzzle = puzzle_fixture()
      assert {:error, %Ecto.Changeset{}} = Puzzles.update_puzzle(puzzle, @invalid_attrs)
      assert puzzle == Puzzles.get_puzzle!(puzzle.id)
    end

    test "delete_puzzle/1 deletes the puzzle" do
      puzzle = puzzle_fixture()
      assert {:ok, %Puzzle{}} = Puzzles.delete_puzzle(puzzle)
      assert_raise Ecto.NoResultsError, fn -> Puzzles.get_puzzle!(puzzle.id) end
    end

    test "change_puzzle/1 returns a puzzle changeset" do
      puzzle = puzzle_fixture()
      assert %Ecto.Changeset{} = Puzzles.change_puzzle(puzzle)
    end
  end
end
