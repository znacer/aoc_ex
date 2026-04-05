defmodule AocExWeb.PageController do
  use AocExWeb, :controller

  alias AocEx.Puzzles
  alias AocEx.Puzzles.Solver

  def home(conn, _params) do
    puzzles = Puzzles.list_puzzles()

    recent_puzzles_with_solutions =
      puzzles
      |> Enum.take(6)
      |> Enum.map(fn puzzle ->
        %{puzzle: puzzle, solution: Solver.for_puzzle(puzzle)}
      end)

    render(conn, :home,
      latest_puzzle: List.first(puzzles),
      recent_puzzles: recent_puzzles_with_solutions,
      puzzle_count: length(puzzles)
    )
  end
end
