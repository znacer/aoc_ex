defmodule AocExWeb.PageControllerTest do
  use AocExWeb.ConnCase
  import AocEx.PuzzlesFixtures

  test "GET /", %{conn: conn} do
    _puzzle = puzzle_fixture(%{year: 2026, day: 1, title: "Calorie Counting"})

    conn = get(conn, ~p"/")
    html = html_response(conn, 200)

    assert html =~ "A puzzle archive built for winter nights and stubborn bugs."
    assert html =~ "Browse archive"
    assert html =~ "Calorie Counting"
  end
end
