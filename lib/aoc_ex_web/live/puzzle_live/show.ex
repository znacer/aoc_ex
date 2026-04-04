defmodule AocExWeb.PuzzleLive.Show do
  use AocExWeb, :live_view

  alias AocEx.Puzzles
  alias AocEx.Puzzles.Solver
  import Puzzles.Solver, only: [pad_day: 1]

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <section class="relative overflow-hidden rounded-[2rem] border border-base-300 bg-base-100 shadow-2xl shadow-base-content/5">
        <div class="relative space-y-10 p-6 sm:p-8">
          <.header>
            <div class="space-y-4">
              <div class="flex flex-wrap items-center gap-3">
                <span class="inline-flex items-center rounded-full border border-warning/30 bg-warning/10 px-3 py-1 text-xs font-semibold uppercase tracking-[0.3em] text-warning">
                  Advent of Code
                </span>
                <span class="inline-flex items-center rounded-full border border-base-300 bg-base-200 px-3 py-1 text-sm font-medium text-base-content/70">
                  {@puzzle.year} / Day {pad_day(@puzzle.day)}
                </span>
                <span class={status_badge_classes(@solution.status)} id="puzzle-solver-status">
                  {status_label(@solution.status)}
                </span>
                <%= if @solution.has_visualization do %>
                  <button
                    phx-click="toggle_visualization"
                    class={[
                      "inline-flex items-center gap-2 rounded-full border px-3 py-1 text-sm font-medium transition-all duration-200",
                      if(@show_visualization,
                        do: "border-primary/30 bg-primary/10 text-primary hover:bg-primary/20",
                        else: "border-base-300 bg-base-200 text-base-content/70 hover:bg-base-300"
                      )
                    ]}
                    id="visualization-toggle"
                  >
                    <.icon
                      name={if(@show_visualization, do: "hero-eye", else: "hero-eye-slash")}
                      class="size-4"
                    />
                    {if(@show_visualization, do: "Hide Viz", else: "Show Viz")}
                  </button>
                <% end %>
              </div>

              <div>
                <h1 class="font-serif text-3xl font-semibold tracking-tight text-balance sm:text-4xl">
                  {@puzzle.title}
                </h1>
                <p class="mt-3 max-w-3xl text-sm leading-7 text-base-content/70 sm:text-base">
                  Problem text comes from the database. Answers are computed from the solver module for this day.
                </p>
              </div>
            </div>

            <:actions>
              <div class="flex items-center gap-3">
                <.button navigate={~p"/puzzles"}>
                  <.icon name="hero-arrow-left" /> Back
                </.button>
                <.button variant="primary" navigate={~p"/puzzles/#{@puzzle}/edit?return_to=show"}>
                  <.icon name="hero-pencil-square" /> Edit puzzle
                </.button>
              </div>
            </:actions>
          </.header>

          <div class="grid gap-6 xl:grid-cols-[minmax(0,1.4fr)_minmax(22rem,0.9fr)]">
            <section
              id="puzzle-problem"
              class="card"
            >
              <%!-- <div class="flex items-center gap-3"> --%>
              <div class="card-title">
                <.icon name="hero-document-text" class="size-5" />
                <div>
                  <h2 class="text-lg font-semibold">Problem</h2>
                  <p class="text-sm text-base-content/65">Stored puzzle statement for both parts.</p>
                </div>
              </div>
              <div class="card-body">
                <div tabindex="0" class="collapse collapse-arrow bg-base-100 border-base-300 border">
                  <div class="collapse-title font-semibold after:start-5 after:end-auto pe-4 ps-12">
                    Example
                  </div>
                  <div class="collapse-content text-sm max-h-32 overflow-scroll">
                    {@puzzle.example}
                  </div>
                </div>
                <div tabindex="0" class="collapse collapse-arrow bg-base-100 border-base-300 border">
                  <div class="collapse-title font-semibold after:start-5 after:end-auto pe-4 ps-12">
                    Part 1
                  </div>
                  <div class="collapse-content text-sm max-h-32 overflow-scroll">
                    {@puzzle.part1}
                  </div>
                </div>
                <div tabindex="0" class="collapse collapse-arrow bg-base-100 border-base-300 border">
                  <div class="collapse-title font-semibold after:start-5 after:end-auto pe-4 ps-12">
                    Part 2
                  </div>
                  <div class="collapse-content text-sm max-h-32 overflow-scroll">
                    {@puzzle.part2}
                  </div>
                </div>
              </div>
            </section>

            <section id="puzzle-solution" class="space-y-5">
              <div class="rounded-[1.5rem] border border-base-300 bg-base-100 p-5 shadow-sm sm:p-6">
                <div class="flex items-center gap-3">
                  <div class="flex size-11 items-center justify-center rounded-2xl bg-primary text-primary-content">
                    <.icon name="hero-bolt" class="size-5" />
                  </div>
                  <div>
                    <h2 class="text-lg font-semibold">Computed Solution</h2>
                    <p class="text-sm text-base-content/65">
                      {@solution.module}
                    </p>
                  </div>
                </div>

                <div class="mt-6 space-y-4">
                  <div class="rounded-[1.25rem] border border-base-300 bg-base-200/50 p-4">
                    <p class="text-xs font-semibold uppercase tracking-[0.25em] text-base-content/45">
                      Expected file
                    </p>
                    <p class="mt-2 font-mono text-sm text-base-content/80">{@solution.file_path}</p>
                  </div>

                  <%= case @solution.status do %>
                    <% :solved -> %>
                      <div class="grid gap-4 sm:grid-cols-2">
                        <article class="rounded-[1.25rem] border border-success/20 bg-success/8 p-4">
                          <p class="text-xs font-semibold uppercase tracking-[0.25em] text-success">
                            Part 1 answer
                          </p>
                          <p class="mt-3 break-words font-mono text-lg font-semibold text-base-content">
                            {@solution.part1}
                          </p>
                        </article>

                        <article class="rounded-[1.25rem] border border-success/20 bg-success/8 p-4">
                          <p class="text-xs font-semibold uppercase tracking-[0.25em] text-success">
                            Part 2 answer
                          </p>
                          <p class="mt-3 break-words font-mono text-lg font-semibold text-base-content">
                            {@solution.part2}
                          </p>
                        </article>
                      </div>
                    <% :missing -> %>
                      <div class="rounded-[1.25rem] border border-warning/30 bg-warning/10 p-4">
                        <div class="flex items-start gap-3">
                          <.icon name="hero-wrench-screwdriver" class="mt-0.5 size-5 text-warning" />
                          <div class="space-y-2 text-sm leading-6 text-base-content/80">
                            <p class="font-semibold text-base-content">
                              Solver module not found yet.
                            </p>
                            <p>
                              Create the file above and define either `solve/0` or both `part1/0` and `part2/0`.
                            </p>
                          </div>
                        </div>
                      </div>
                    <% :error -> %>
                      <div class="rounded-[1.25rem] border border-error/30 bg-error/10 p-4">
                        <div class="flex items-start gap-3">
                          <.icon name="hero-exclamation-triangle" class="mt-0.5 size-5 text-error" />
                          <div class="space-y-2">
                            <p class="font-semibold text-base-content">The solver raised an error.</p>
                            <p class="whitespace-pre-wrap break-words font-mono text-sm text-base-content/80">
                              {@solution.error}
                            </p>
                          </div>
                        </div>
                      </div>
                  <% end %>
                </div>
              </div>
            </section>
          </div>

          <%= if @show_visualization && @solution.has_visualization do %>
            <section
              id="puzzle-visualization"
              class="rounded-[1.5rem] border border-base-300 bg-base-100 p-6 shadow-sm"
            >
              <div class="flex items-center gap-3 mb-6">
                <div class="flex size-11 items-center justify-center rounded-2xl bg-accent text-accent-content">
                  <.icon name="hero-chart-bar-square" class="size-5" />
                </div>
                <div>
                  <h2 class="text-lg font-semibold">Visualization</h2>
                  <p class="text-sm text-base-content/65">
                    Interactive representation of the puzzle solution.
                  </p>
                </div>
              </div>

              <div class="rounded-xl border border-base-200 bg-base-50/50 p-4">
                {render_visualization(@solution.module, assigns)}
              </div>
            </section>
          <% end %>
        </div>
      </section>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    puzzle = Puzzles.get_puzzle!(id)
    solution = Solver.for_puzzle(puzzle)

    {:ok,
     socket
     |> assign(:page_title, puzzle_title(puzzle))
     |> assign(:puzzle, puzzle)
     |> assign(:solution, solution)
     |> assign(:show_visualization, solution.has_visualization)}
  end

  @impl true
  def handle_event("toggle_visualization", _params, socket) do
    {:noreply, update(socket, :show_visualization, fn val -> not val end)}
  end

  defp puzzle_title(puzzle), do: "#{puzzle.year} Day #{pad_day(puzzle.day)}"

  defp status_label(:solved), do: "Solver Loaded"
  defp status_label(:missing), do: "Solver Missing"
  defp status_label(:error), do: "Solver Error"

  defp status_badge_classes(:solved) do
    "inline-flex items-center rounded-full border border-success/30 bg-success/10 px-3 py-1 text-sm font-medium text-success"
  end

  defp status_badge_classes(:missing) do
    "inline-flex items-center rounded-full border border-warning/30 bg-warning/10 px-3 py-1 text-sm font-medium text-warning"
  end

  defp status_badge_classes(:error) do
    "inline-flex items-center rounded-full border border-error/30 bg-error/10 px-3 py-1 text-sm font-medium text-error"
  end

  defp render_visualization(module, assigns) do
    case Solver.visualization_module(module) do
      nil ->
        ~H"""
        <p class="text-sm text-base-content/60 italic">No visualization available.</p>
        """

      viz_module ->
        apply(viz_module, :render, [assigns])
    end
  end
end
