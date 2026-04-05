# 🎄 AocEx — Advent of Code in Elixir & Phoenix

A modern, interactive web application for solving and visualizing [Advent of Code](https://adventofcode.com/) challenges. Built with **Elixir**, **Phoenix 1.8**, and **LiveView**, featuring optional **d3.js** visualizations that bring each day's puzzle to life.

## ✨ Features

- 🧩 **Puzzle Management** — Store and browse AoC puzzles by year and day
- ⚡ **Live Solutions** — Compute answers on-demand via modular Elixir solvers
- 📊 **Interactive Visualizations** — Optional, client-side d3.js visualizations embedded directly in solution files
- 🎨 **Beautiful UI** — Polished interface with Tailwind CSS, daisyUI, and smooth LiveView transitions
- 🔄 **Real-time Updates** — Toggle visualizations, scrub through steps with sliders, and watch results update instantly
- 🛠 **Developer Friendly** — Hot reloading, `mix precommit` checks, and clean architecture

## 🛠 Tech Stack

| Layer        | Technology                          |
|--------------|-------------------------------------|
| **Backend**  | Elixir, Phoenix 1.8, Phoenix LiveView |
| **Database** | PostgreSQL, Ecto                    |
| **Frontend** | HEEx, Tailwind CSS v4, daisyUI      |
| **Viz**      | d3.js, Colocated JS Hooks           |
| **Tooling**  | esbuild, Req, Jason                 |

## 🚀 Getting Started

### Prerequisites
- Elixir `~> 1.15` & OTP
- PostgreSQL
- Node.js (for asset building)

### Setup
```bash
# Clone the repo
git clone https://github.com/your-username/aoc_ex.git
cd aoc_ex

# Install dependencies, create DB, and build assets
mix setup

# Start the Phoenix server
mix phx.server
```

Visit [http://localhost:4000](http://localhost:4000) to see the app in action.

## 📁 Project Structure

```
lib/
├── aoc_ex/
│   ├── puzzles/          # Puzzle context & Ecto schemas
│   └── solutions/        # Solver modules (Y2025/day01.ex, etc.)
└── aoc_ex_web/
    ├── live/             # LiveViews (Puzzle index, show, form)
    ├── components/       # Reusable HEEx components
    └── router.ex         # Route definitions

assets/
├── js/app.js             # d3.js import & LiveSocket setup
└── css/app.css           # Tailwind v4 imports
```

## 📝 Adding a New Day

1. **Create the solver module** at `lib/aoc_ex/solutions/y{year}/day{day}.ex`:
```elixir
defmodule AocEx.Solutions.Y2025.Day03 do
  def part1 do
    # Your solution logic here
    42
  end

  def part2 do
    # Part 2 logic
    1337
  end
end
```

2. **Add the puzzle to the database** via the web UI (`/puzzles/new`) or seeds.
3. The app will automatically detect your module, run it, and display the results on the puzzle page.

## 🎨 Adding Visualizations

Visualizations are **completely optional**. To add one, define a nested `Visualization` module in your day's solution file:

```elixir
defmodule AocEx.Solutions.Y2025.Day01 do
  def part1, do: ...
  def part2, do: ...

  defmodule Visualization do
    use Phoenix.Component

    def render(assigns) do
      # Prepare your data
      step_data = compute_step_data()

      assigns =
        assigns
        |> assign(:step_data, step_data)
        |> assign(:total_steps, length(step_data) - 1)

      ~H"""
      <div id="day01-viz" class="space-y-6">
        <!-- SVG container for d3.js -->
        <svg id="clock-svg" width="340" height="340"
             phx-hook=".Day01Clock"
             data-steps={Jason.encode!(@step_data)}>
        </svg>

        <!-- Controls -->
        <input type="range" id="step-slider" min="0" max={@total_steps} />

        <!-- Colocated JS Hook -->
        <script :type={Phoenix.LiveView.ColocatedHook} name=".Day01Clock">
          export default {
            mounted() {
              const steps = JSON.parse(this.el.dataset.steps);
              const svg = d3.select(this.el);
              // ... d3 rendering logic ...
            }
          }
        </script>
      </div>
      """
    end
  end
end
```

### How it works
- The `Solver` module automatically detects if a `Visualization` nested module exists.
- A **"Show Viz"** toggle appears on the puzzle page when a visualization is available.
- Visualizations run client-side using **d3.js** (imported in `app.js` and exposed as `window.d3`).
- Use **colocated JS hooks** (`:type={Phoenix.LiveView.ColocatedHook}`) to keep JS tightly coupled with your HEEx template.

## 🧪 Development & Testing

```bash
# Run the test suite
mix test

# Run tests for a specific day
mix test test/aoc_ex/solutions/y2025/day01_test.exs

# Precommit checks (compile with warnings-as-errors, format, test)
mix precommit
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-day`)
3. Commit your changes (`git commit -m 'Add Day 05 solution & visualization'`)
4. Push to the branch (`git push origin feature/amazing-day`)
5. Open a Pull Request

## 📜 License

This project is open source and available under the [MIT License](LICENSE).

---

Built with ❤️ using [Phoenix Framework](https://www.phoenixframework.org/) & [Elixir](https://elixir-lang.org/)
