defmodule AocEx.Puzzles.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzles" do
    field :year, :integer
    field :day, :integer
    field :title, :string
    field :example, :string
    field :part1, :string
    field :part2, :string

    timestamps(type: :utc_datetime)
  end

  @type t() :: %__MODULE__{
          year: integer(),
          day: integer(),
          title: String.t(),
          example: String.t() | nil,
          part1: String.t() | nil,
          part2: String.t() | nil
        }

  @doc false
  def changeset(puzzle, attrs) do
    puzzle
    |> cast(attrs, [:year, :day, :title, :example, :part1, :part2])
    |> validate_required([:year, :day, :title, :part1])
  end
end
