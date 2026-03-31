defmodule AocEx.Repo.Migrations.CreatePuzzles do
  use Ecto.Migration

  def change do
    create table(:puzzles) do
      add :year, :integer
      add :day, :integer
      add :title, :string
      add :part1, :text
      add :part2, :text

      timestamps(type: :utc_datetime)
    end
  end
end
