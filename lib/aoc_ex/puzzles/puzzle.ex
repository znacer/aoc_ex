defmodule AocEx.Puzzles.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzles" do
    field :year, :integer
    field :day, :integer
    field :title, :string
    field :part1, :string
    field :part2, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(puzzle, attrs) do
    puzzle
    |> cast(attrs, [:year, :day, :title, :part1, :part2])
    |> validate_required([:year, :day, :title, :part1, :part2])
  end
end
