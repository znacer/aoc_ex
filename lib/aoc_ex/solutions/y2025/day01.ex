defmodule AocEx.Solutions.Y2025.Day01 do
  alias AocEx.Puzzles

  def part1 do
    puzzle = Puzzles.get_puzzle!(2025, 1).part1
    start = 50

    solution =
      puzzle
      |> String.split("\n", trim: true)
      |> Enum.reduce({start, 0}, fn line, {current_pos, count} ->
        new_pos = Integer.mod(current_pos + parse_line(line), 100)

        new_count = if new_pos == 0, do: count + 1, else: count
        {new_pos, new_count}
      end)
      |> elem(1)

    solution
  end

  def part2 do
    puzzle = Puzzles.get_puzzle!(2025, 1).part1
    start = 50

    puzzle
    |> String.split("\n", trim: true)
    |> Enum.reduce({start, 0}, fn line, {pos, count} ->
      move = parse_line(line)
      new_pos = Integer.mod(pos + move, 100)

      full_laps = div(abs(move), 100)
      remainder = rem(abs(move), 100)

      crossed =
        cond do
          pos == 0 -> 0
          move < 0 -> if remainder >= pos, do: 1, else: 0
          move > 0 -> if remainder >= 100 - pos, do: 1, else: 0
        end

      zeros = full_laps + crossed

      {new_pos, count + zeros}
    end)
    |> elem(1)
  end

  defp parse_line(line) do
    {sign, nb} = String.split_at(line, 1)

    sign =
      case sign do
        "R" -> +1
        _ -> -1
      end

    String.to_integer(nb) * sign
  end

  defmodule Visualization do
    use Phoenix.Component
    alias AocEx.Puzzles

    def render(assigns) do
      puzzle = Puzzles.get_puzzle!(2025, 1).part1
      start = 50

      steps =
        puzzle
        |> String.split("\n", trim: true)
        |> Enum.with_index()
        |> Enum.scan({start, 0, 0, []}, fn {line, idx}, {_prev_pos, crossings, landed, history} ->
          move = parse_line(line)
          prev_pos = if idx == 0, do: start, else: List.first(history) |> elem(0)
          new_pos = Integer.mod(prev_pos + move, 100)

          full_laps = div(abs(move), 100)
          remainder = rem(abs(move), 100)

          crossed =
            cond do
              prev_pos == 0 -> 0
              move < 0 -> if remainder >= prev_pos, do: 1, else: 0
              move > 0 -> if remainder >= 100 - prev_pos, do: 1, else: 0
            end

          new_crossings = crossings + full_laps + crossed
          new_landed = if new_pos == 0, do: landed + 1, else: landed

          {[{new_pos, move}], new_crossings, new_landed, [{new_pos, move} | history]}
        end)

      step_data =
        [[start, 0]] ++
          Enum.map(steps, fn {_pos, crossings, landed, history} ->
            {pos, move} = List.first(history)
            [pos, move, crossings, landed]
          end)

      assigns =
        assigns
        |> assign(:start, start)
        |> assign(:step_data, step_data)
        |> assign(:total_steps, length(step_data) - 1)

      ~H"""
      <div class="space-y-6" id="day01-viz">
        <div class="flex items-center justify-between">
          <h3 class="text-lg font-semibold text-base-content">Clock Visualization</h3>
          <span class="text-xs text-base-content/60">
            Steps: 0 → {@total_steps}
          </span>
        </div>

        <div class="flex flex-col items-center gap-6 lg:flex-row lg:items-start lg:justify-center">
          <div class="relative">
            <svg
              id="clock-svg"
              width="340"
              height="340"
              class="drop-shadow-lg"
              phx-hook=".Day01Clock"
              data-start={@start}
              data-steps={Jason.encode!(@step_data)}
            >
            </svg>
          </div>

          <div class="w-full max-w-sm space-y-4">
            <div class="rounded-xl border border-base-200 bg-base-50 p-4">
              <div class="flex justify-between">
                <div class="btn" id="prev-btn">Prev</div>
                <div class="btn" id="next-btn">Next</div>
              </div>
              <label for="step-slider" class="mb-2 block text-sm font-medium text-base-content/80">
                Step: <span id="step-display" class="font-mono font-bold text-primary">0</span>
              </label>
              <input
                type="range"
                id="step-slider"
                min="0"
                max={@total_steps}
                value="0"
                step="1"
                class="w-full accent-primary"
                phx-update="ignore"
              />
              <div class="mt-2 flex justify-between text-xs text-base-content/60">
                <span>Start ({@start})</span>
                <span>End</span>
              </div>
            </div>

            <div class="grid grid-cols-2 gap-3">
              <div class="rounded-lg border border-base-200 bg-base-50 p-3 text-center">
                <p class="text-xs font-medium uppercase tracking-wide text-base-content/60">
                  Position
                </p>
                <p id="position-display" class="mt-1 text-3xl font-bold font-mono text-primary">
                  {@start}
                </p>
              </div>
              <div class="rounded-lg border border-base-200 bg-base-50 p-3 text-center">
                <p class="text-xs font-medium uppercase tracking-wide text-base-content/60">
                  Move
                </p>
                <p id="move-display" class="mt-1 text-3xl font-bold font-mono text-accent">
                  0
                </p>
              </div>
              <div class="rounded-lg border border-success/20 bg-success/5 p-3 text-center">
                <p class="text-xs font-medium uppercase tracking-wide text-success/80">
                  Crossed 0
                </p>
                <p id="crossings-display" class="mt-1 text-2xl font-bold font-mono text-success">
                  0
                </p>
              </div>
              <div class="rounded-lg border border-warning/20 bg-warning/5 p-3 text-center">
                <p class="text-xs font-medium uppercase tracking-wide text-warning/80">
                  Landed on 0
                </p>
                <p id="landed-display" class="mt-1 text-2xl font-bold font-mono text-warning">
                  0
                </p>
              </div>
            </div>
          </div>
        </div>

        <script :type={Phoenix.LiveView.ColocatedHook} name=".Day01Clock">
          export default {
            mounted() {
              const start = parseInt(this.el.dataset.start);
              const steps = JSON.parse(this.el.dataset.steps);
              const slider = document.getElementById("step-slider");
              const stepDisplay = document.getElementById("step-display");
              const positionDisplay = document.getElementById("position-display");
              const moveDisplay = document.getElementById("move-display");
              const crossingsDisplay = document.getElementById("crossings-display");
              const landedDisplay = document.getElementById("landed-display");

              const width = 340;
              const height = 340;
              const cx = width / 2;
              const cy = height / 2;
              const radius = 130;

              const svg = d3.select(this.el)
                .attr("viewBox", `0 0 ${width} ${height}`);

              function cssVar(name) {
                c = getComputedStyle(document.documentElement).getPropertyValue(name).trim();
              console.log(name, c)
                return c
              }

              function positionToAngle(pos) {
                return ((pos - 25) % 100) * (2 * Math.PI / 100) - Math.PI / 2;
              }

              function drawClock(step) {
                svg.selectAll("*").remove();

                const visitedPositions = new Set();
                for (let i = 0; i <= step; i++) {
                  visitedPositions.add(steps[i][0]);
                }

                // Background circle
                svg.append("circle")
                  .attr("cx", cx)
                  .attr("cy", cy)
                  .attr("r", radius + 15)
                  .attr("fill", `${cssVar("--color-neutral")}`)
                  .attr("stroke", `${cssVar("--color-primary-content")} / 0.1`)
                  .attr("stroke-width", 2);

                // Tick marks
                const ticks = d3.range(100).map(pos => {
                  const angle = positionToAngle(pos);
                  const isMajor = pos % 10 === 0;
                  const tickLen = isMajor ? 14 : 6;
                  const tickWidth = isMajor ? 2.5 : 1;
                  const x1 = cx + (radius - tickLen) * Math.cos(angle);
                  const y1 = cy + (radius - tickLen) * Math.sin(angle);
                  const x2 = cx + radius * Math.cos(angle);
                  const y2 = cy + radius * Math.sin(angle);
                  return { pos, x1, y1, x2, y2, isMajor, tickWidth, visited: visitedPositions.has(pos) };
                });

                svg.selectAll(".tick")
                  .data(ticks)
                  .join("line")
                  .attr("class", "tick")
                  .attr("x1", d => d.x1)
                  .attr("y1", d => d.y1)
                  .attr("x2", d => d.x2)
                  .attr("y2", d => d.y2)
                  .attr("stroke", d => d.visited ? `${cssVar("--color-primary")}` : `${cssVar("--color-primary")} / 0.25`)
                  .attr("stroke-width", d => d.tickWidth)
                  .attr("stroke-linecap", "round");

                // Labels for major ticks
                const labels = d3.range(0, 100, 10).map(pos => {
                  const angle = positionToAngle(pos);
                  const labelRadius = radius - 26;
                  return {
                    pos,
                    x: cx + labelRadius * Math.cos(angle),
                    y: cy + labelRadius * Math.sin(angle)
                  };
                });

                svg.selectAll(".tick-label")
                  .data(labels)
                  .join("text")
                  .attr("class", "tick-label")
                  .attr("x", d => d.x)
                  .attr("y", d => d.y)
                  .attr("text-anchor", "middle")
                  .attr("dominant-baseline", "central")
                  .attr("fill", `${cssVar("--color-primary-content")}`)
                  .attr("font-size", 13)
                  .attr("font-weight", 600)
                  .text(d => d.pos);

                // Needle
                const currentPos = steps[step][0];
                const needleAngle = positionToAngle(currentPos);
                const needleLen = radius - 35;
                const nx = cx + needleLen * Math.cos(needleAngle);
                const ny = cy + needleLen * Math.sin(needleAngle);

                svg.append("line")
                  .attr("x1", cx)
                  .attr("y1", cy)
                  .attr("x2", nx)
                  .attr("y2", ny)
                  .attr("stroke", `${cssVar("--color-primary")}`)
                  .attr("stroke-width", 3.5)
                  .attr("stroke-linecap", "round");

                // Center dot
                svg.append("circle")
                  .attr("cx", cx)
                  .attr("cy", cy)
                  .attr("r", 7)
                  .attr("fill", `${cssVar("--color-primary")}`);

                // Position label in center
                svg.append("text")
                  .attr("x", cx)
                  .attr("y", cy + 45)
                  .attr("text-anchor", "middle")
                  .attr("fill", `${cssVar("--color-primary-content")}`)
                  .attr("font-size", 26)
                  .attr("font-weight", "bold")
                  .attr("font-family", "monospace")
                  .text(currentPos);
              }

              function updateDisplay(step) {
                const [pos, move, crossings, landed] = steps[step];
                stepDisplay.textContent = step;
                positionDisplay.textContent = pos;
                moveDisplay.textContent = (move >= 0 ? "+" : "") + move;
                crossingsDisplay.textContent = crossings;
                landedDisplay.textContent = landed;
                drawClock(step);
              }

              slider.addEventListener("input", (e) => {
                updateDisplay(parseInt(e.target.value));
              });

              document.getElementById("prev-btn").addEventListener("click", () => {
                slider.value = Math.max(0, parseInt(slider.value) - 1);
                updateDisplay(parseInt(slider.value));
              });
              document.getElementById("next-btn").addEventListener("click", () => {
                slider.value = Math.min(steps.length - 1, parseInt(slider.value) + 1);
                updateDisplay(parseInt(slider.value));
              });

              updateDisplay(0);
            }
          }
        </script>
      </div>
      """
    end

    defp parse_line(line) do
      {sign, nb} = String.split_at(line, 1)

      sign =
        case sign do
          "R" -> +1
          _ -> -1
        end

      String.to_integer(nb) * sign
    end
  end
end
