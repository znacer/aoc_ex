defmodule AocExWeb.PuzzleLive.Index do
  use AocExWeb, :live_view

  alias AocEx.Puzzles

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Puzzles
        <:actions>
          <.button variant="primary" navigate={~p"/puzzles/new"}>
            <.icon name="hero-plus" /> New Puzzle
          </.button>
        </:actions>
      </.header>

      <.table
        id="puzzles"
        rows={@streams.puzzles}
        row_click={fn {_id, puzzle} -> JS.navigate(~p"/puzzles/#{puzzle}") end}
      >
        <:col :let={{_id, puzzle}} label="Year">{puzzle.year}</:col>
        <:col :let={{_id, puzzle}} label="Day">{puzzle.day}</:col>
        <:col :let={{_id, puzzle}} label="Title">{puzzle.title}</:col>
        <:col :let={{_id, puzzle}} label="Part1">{puzzle.part1}</:col>
        <:col :let={{_id, puzzle}} label="Part2">{puzzle.part2}</:col>
        <:action :let={{_id, puzzle}}>
          <div class="sr-only">
            <.link navigate={~p"/puzzles/#{puzzle}"}>Show</.link>
          </div>
          <.link navigate={~p"/puzzles/#{puzzle}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, puzzle}}>
          <.link
            phx-click={JS.push("delete", value: %{id: puzzle.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Puzzles")
     |> stream(:puzzles, list_puzzles())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    puzzle = Puzzles.get_puzzle!(id)
    {:ok, _} = Puzzles.delete_puzzle(puzzle)

    {:noreply, stream_delete(socket, :puzzles, puzzle)}
  end

  defp list_puzzles() do
    Puzzles.list_puzzles()
  end
end
