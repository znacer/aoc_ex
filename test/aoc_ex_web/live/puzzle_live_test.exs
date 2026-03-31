defmodule AocExWeb.PuzzleLiveTest do
  use AocExWeb.ConnCase

  import Phoenix.LiveViewTest
  import AocEx.PuzzlesFixtures

  @create_attrs %{title: "some title", day: 42, year: 42, part1: "some part1", part2: "some part2"}
  @update_attrs %{title: "some updated title", day: 43, year: 43, part1: "some updated part1", part2: "some updated part2"}
  @invalid_attrs %{title: nil, day: nil, year: nil, part1: nil, part2: nil}
  defp create_puzzle(_) do
    puzzle = puzzle_fixture()

    %{puzzle: puzzle}
  end

  describe "Index" do
    setup [:create_puzzle]

    test "lists all puzzles", %{conn: conn, puzzle: puzzle} do
      {:ok, _index_live, html} = live(conn, ~p"/puzzles")

      assert html =~ "Listing Puzzles"
      assert html =~ puzzle.title
    end

    test "saves new puzzle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/puzzles")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Puzzle")
               |> render_click()
               |> follow_redirect(conn, ~p"/puzzles/new")

      assert render(form_live) =~ "New Puzzle"

      assert form_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#puzzle-form", puzzle: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/puzzles")

      html = render(index_live)
      assert html =~ "Puzzle created successfully"
      assert html =~ "some title"
    end

    test "updates puzzle in listing", %{conn: conn, puzzle: puzzle} do
      {:ok, index_live, _html} = live(conn, ~p"/puzzles")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#puzzles-#{puzzle.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/puzzles/#{puzzle}/edit")

      assert render(form_live) =~ "Edit Puzzle"

      assert form_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#puzzle-form", puzzle: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/puzzles")

      html = render(index_live)
      assert html =~ "Puzzle updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes puzzle in listing", %{conn: conn, puzzle: puzzle} do
      {:ok, index_live, _html} = live(conn, ~p"/puzzles")

      assert index_live |> element("#puzzles-#{puzzle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#puzzles-#{puzzle.id}")
    end
  end

  describe "Show" do
    setup [:create_puzzle]

    test "displays puzzle", %{conn: conn, puzzle: puzzle} do
      {:ok, _show_live, html} = live(conn, ~p"/puzzles/#{puzzle}")

      assert html =~ "Show Puzzle"
      assert html =~ puzzle.title
    end

    test "updates puzzle and returns to show", %{conn: conn, puzzle: puzzle} do
      {:ok, show_live, _html} = live(conn, ~p"/puzzles/#{puzzle}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/puzzles/#{puzzle}/edit?return_to=show")

      assert render(form_live) =~ "Edit Puzzle"

      assert form_live
             |> form("#puzzle-form", puzzle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#puzzle-form", puzzle: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/puzzles/#{puzzle}")

      html = render(show_live)
      assert html =~ "Puzzle updated successfully"
      assert html =~ "some updated title"
    end
  end
end
