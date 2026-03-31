defmodule AocExWeb.PuzzleLive.Show do
  use AocExWeb, :live_view

  alias AocEx.Puzzles

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Puzzle {@puzzle.id}
        <:subtitle>This is a puzzle record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/puzzles"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/puzzles/#{@puzzle}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit puzzle
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Year">{@puzzle.year}</:item>
        <:item title="Day">{@puzzle.day}</:item>
        <:item title="Title">{@puzzle.title}</:item>
        <:item title="Part1">{@puzzle.part1}</:item>
        <:item title="Part2">{@puzzle.part2}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Puzzle")
     |> assign(:puzzle, Puzzles.get_puzzle!(id))}
  end
end
