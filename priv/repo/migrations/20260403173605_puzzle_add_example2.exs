defmodule AocEx.Repo.Migrations.PuzzleAddExample2 do
  use Ecto.Migration

  def change do
    alter table("puzzles") do
      add :example, :string
    end
  end
end
