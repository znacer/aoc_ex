defmodule AocEx.Puzzles do
  @moduledoc """
  The Puzzles context.
  """

  import Ecto.Query, warn: false
  alias AocEx.Repo

  alias AocEx.Puzzles.Puzzle

  @doc """
  Returns the list of puzzles.

  ## Examples

      iex> list_puzzles()
      [%Puzzle{}, ...]

  """
  def list_puzzles do
    Puzzle
    |> order_by([p], desc: p.year, asc: p.day)
    |> Repo.all()
  end

  @doc """
  Gets a single puzzle.

  Raises `Ecto.NoResultsError` if the Puzzle does not exist.

  ## Examples

      iex> get_puzzle!(123)
      %Puzzle{}

      iex> get_puzzle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_puzzle!(id), do: Repo.get!(Puzzle, id)

  @doc """
  Creates a puzzle.

  ## Examples

      iex> create_puzzle(%{field: value})
      {:ok, %Puzzle{}}

      iex> create_puzzle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_puzzle(attrs) do
    %Puzzle{}
    |> Puzzle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a puzzle.

  ## Examples

      iex> update_puzzle(puzzle, %{field: new_value})
      {:ok, %Puzzle{}}

      iex> update_puzzle(puzzle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_puzzle(%Puzzle{} = puzzle, attrs) do
    puzzle
    |> Puzzle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a puzzle.

  ## Examples

      iex> delete_puzzle(puzzle)
      {:ok, %Puzzle{}}

      iex> delete_puzzle(puzzle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_puzzle(%Puzzle{} = puzzle) do
    Repo.delete(puzzle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking puzzle changes.

  ## Examples

      iex> change_puzzle(puzzle)
      %Ecto.Changeset{data: %Puzzle{}}

  """
  def change_puzzle(%Puzzle{} = puzzle, attrs \\ %{}) do
    Puzzle.changeset(puzzle, attrs)
  end

  @doc """
  Get a single puzzle from a year and a day.

  ## Examples

      iex> get_puzzle!(2025, 1)
      %Puzzle{}

  """
  def get_puzzle!(year, day) do
    Repo.get_by!(Puzzle, year: year, day: day)
  end
end
