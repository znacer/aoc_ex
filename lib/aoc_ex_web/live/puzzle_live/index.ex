defmodule AocExWeb.PuzzleLive.Index do
  use AocExWeb, :live_view

  alias AocEx.Puzzles
  import Puzzles.Solver, only: [pad_day: 1]

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <section class="space-y-8">
        <section class="relative overflow-hidden rounded-[2rem] border border-base-300 bg-base-100 shadow-2xl shadow-base-content/5">
          <div class="absolute inset-0 bg-[radial-gradient(circle_at_top_left,_rgba(251,191,36,0.18),_transparent_30%),radial-gradient(circle_at_80%_20%,_rgba(34,197,94,0.15),_transparent_26%),linear-gradient(135deg,rgba(15,23,42,0.06),transparent_45%)]" />
          <div class="relative space-y-8 p-6 sm:p-8">
            <.header>
              <div class="space-y-4">
                <div class="flex flex-wrap items-center gap-3">
                  <span class="inline-flex items-center rounded-full border border-warning/30 bg-warning/10 px-3 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-warning">
                    Puzzle Archive
                  </span>
                  <span class="inline-flex items-center rounded-full border border-base-300 bg-base-200 px-3 py-1 text-sm text-base-content/65">
                    {@puzzle_count} entries
                  </span>
                </div>
                <div>
                  <h1 class="font-serif text-3xl font-semibold tracking-tight text-balance sm:text-4xl">
                    Advent of Code, organized by day instead of buried in scripts.
                  </h1>
                  <p class="mt-3 max-w-3xl text-sm leading-7 text-base-content/70 sm:text-base">
                    Browse each completion, inspect the prompt, and jump straight to the computed answer page.
                  </p>
                </div>
              </div>

              <:actions>
                <div class="flex items-center gap-3">
                  <.button navigate={~p"/"}>
                    <.icon name="hero-home" /> Home
                  </.button>
                  <.button variant="primary" navigate={~p"/puzzles/new"}>
                    <.icon name="hero-plus" /> New Puzzle
                  </.button>
                </div>
              </:actions>
            </.header>

            <div class="grid gap-4 sm:grid-cols-3">
              <article class="rounded-[1.25rem] border border-base-300 bg-base-100/85 p-4 backdrop-blur">
                <p class="text-xs font-semibold uppercase tracking-[0.25em] text-base-content/45">
                  Years tracked
                </p>
                <p class="mt-3 font-mono text-3xl font-semibold">{@year_count}</p>
              </article>
              <article class="rounded-[1.25rem] border border-base-300 bg-base-100/85 p-4 backdrop-blur">
                <p class="text-xs font-semibold uppercase tracking-[0.25em] text-base-content/45">
                  Latest year
                </p>
                <p class="mt-3 font-mono text-3xl font-semibold">{@latest_year || "None"}</p>
              </article>
              <article class="rounded-[1.25rem] border border-base-300 bg-base-100/85 p-4 backdrop-blur">
                <p class="text-xs font-semibold uppercase tracking-[0.25em] text-base-content/45">
                  Latest day
                </p>
                <p class="mt-3 font-mono text-3xl font-semibold">{format_latest_day(@latest_day)}</p>
              </article>
            </div>
          </div>
        </section>

        <section class="rounded-[2rem] border border-base-300 bg-base-100 p-4 shadow-sm sm:p-6">
          <div id="puzzles" class="space-y-4" phx-update="stream">
            <div
              id="puzzles-empty"
              class="hidden rounded-[1.25rem] border border-dashed border-base-300 bg-base-200/60 p-8 text-center text-sm text-base-content/65 only:block"
            >
              No puzzles yet. Create the first puzzle entry to start the archive.
            </div>

            <article
              :for={{id, puzzle} <- @streams.puzzles}
              id={id}
              class="group rounded-[1.5rem] border border-base-300 bg-base-100 p-5 transition hover:-translate-y-0.5 hover:border-primary/25 hover:shadow-lg hover:shadow-base-content/5"
            >
              <div class="flex flex-col gap-5 lg:flex-row lg:items-start lg:justify-between">
                <div class="min-w-0 space-y-4">
                  <div class="flex flex-wrap items-center gap-3">
                    <span class="inline-flex items-center rounded-full bg-base-200 px-3 py-1 font-mono text-xs font-semibold text-base-content/65">
                      {puzzle.year}-{pad_day(puzzle.day)}
                    </span>
                    <h2 class="truncate text-xl font-semibold text-base-content">{puzzle.title}</h2>
                  </div>

                  <div class="grid gap-3 md:grid-cols-2">
                    <div class="rounded-[1.25rem] border border-base-300 bg-base-200/55 p-4">
                      <p class="text-xs font-semibold uppercase tracking-[0.25em] text-base-content/45">
                        Part 1
                      </p>
                      <p class="mt-2 line-clamp-3 text-sm leading-6 text-base-content/72">
                        {puzzle.part1}
                      </p>
                    </div>
                    <div class="rounded-[1.25rem] border border-base-300 bg-base-200/55 p-4">
                      <p class="text-xs font-semibold uppercase tracking-[0.25em] text-base-content/45">
                        Part 2
                      </p>
                      <p class="mt-2 line-clamp-3 text-sm leading-6 text-base-content/72">
                        {puzzle.part2}
                      </p>
                    </div>
                  </div>
                </div>

                <div class="flex shrink-0 flex-wrap items-center gap-3">
                  <.link
                    navigate={~p"/puzzles/#{puzzle}"}
                    class="inline-flex items-center gap-2 rounded-2xl bg-primary px-4 py-2.5 text-sm font-semibold text-primary-content shadow-md shadow-primary/20 transition hover:-translate-y-0.5"
                  >
                    Open <.icon name="hero-arrow-up-right" class="size-4" />
                  </.link>
                  <.link
                    navigate={~p"/puzzles/#{puzzle}/edit"}
                    class="inline-flex items-center gap-2 rounded-2xl border border-base-300 bg-base-100 px-4 py-2.5 text-sm font-semibold text-base-content transition hover:bg-base-200"
                  >
                    <.icon name="hero-pencil-square" class="size-4" /> Edit
                  </.link>
                  <.link
                    phx-click={JS.push("delete", value: %{id: puzzle.id}) |> hide("##{id}")}
                    data-confirm="Are you sure?"
                    class="inline-flex items-center gap-2 rounded-2xl border border-error/20 bg-error/8 px-4 py-2.5 text-sm font-semibold text-error transition hover:bg-error/12"
                  >
                    <.icon name="hero-trash" class="size-4" /> Delete
                  </.link>
                </div>
              </div>
            </article>
          </div>
        </section>
      </section>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    puzzles = list_puzzles()

    {:ok,
     socket
     |> assign(:page_title, "Puzzle Archive")
     |> assign_archive_stats(puzzles)
     |> stream(:puzzles, puzzles)}
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

  defp assign_archive_stats(socket, puzzles) do
    years = puzzles |> Enum.map(& &1.year) |> Enum.uniq()
    latest = List.first(puzzles)

    socket
    |> assign(:puzzle_count, length(puzzles))
    |> assign(:year_count, length(years))
    |> assign(:latest_year, latest && latest.year)
    |> assign(:latest_day, latest && latest.day)
  end

  defp format_latest_day(nil), do: "None"
  defp format_latest_day(day), do: pad_day(day)
end
