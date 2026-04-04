defmodule AocExWeb.PageController do
  use AocExWeb, :controller

  alias AocEx.Puzzles

  def home(conn, _params) do
    puzzles = Puzzles.list_puzzles()

    render(conn, :home,
      latest_puzzle: List.first(puzzles),
      recent_puzzles: Enum.take(puzzles, 6),
      puzzle_count: length(puzzles)
    )
  end
end
