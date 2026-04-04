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
        |> Enum.scan({start, 0}, fn line, {current_pos, count} ->
          new_pos = Integer.mod(current_pos + parse_line(line), 100)
          new_count = if new_pos == 0, do: count + 1, else: count
          {new_pos, new_count}
        end)

      positions = Enum.map(steps, fn {pos, _count} -> pos end)
      zero_crossings = Enum.map(steps, fn {_pos, count} -> count end)

      assigns =
        assigns
        |> assign(:positions, positions)
        |> assign(:zero_crossings, zero_crossings)
        |> assign(:start, start)

      ~H"""
      <div class="space-y-6">
        <div class="flex items-center justify-between">
          <h3 class="text-base font-semibold text-base-content">Position Tracker</h3>
          <span class="text-xs text-base-content/60">
            Start: {@start} | Steps: {length(@positions)} | Zero Crossings: {List.last(@zero_crossings)}
          </span>
        </div>

        <div class="relative h-48 w-full overflow-hidden rounded-lg border border-base-200 bg-base-100">
          <div class="absolute inset-0 flex items-end px-2 pb-2">
            <div class="flex w-full items-end gap-px">
              <%= for {pos, idx} <- Enum.with_index(@positions) do %>
                <div
                  class={[
                    "flex-1 rounded-t transition-all duration-150",
                    if(pos == 0, do: "bg-success", else: "bg-primary/60"),
                    if(idx == length(@positions) - 1, do: "ring-2 ring-primary ring-offset-1")
                  ]}
                  style={"height: #{max(4, pos * 1.5)}px"}
                  title={"Step #{idx + 1}: pos=#{pos}"}
                >
                </div>
              <% end %>
            </div>
          </div>
          <div class="absolute inset-x-0 top-2 flex justify-center">
            <span class="rounded-full bg-base-100/90 px-3 py-1 text-xs font-medium text-base-content/70 shadow-sm">
              Position over time (0 = green, else blue)
            </span>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 text-sm">
          <div class="rounded-lg border border-base-200 bg-base-50 p-3">
            <p class="text-xs font-medium uppercase tracking-wide text-base-content/60">
              Final Position
            </p>
            <p class="mt-1 text-2xl font-bold text-primary">{List.last(@positions)}</p>
          </div>
          <div class="rounded-lg border border-base-200 bg-base-50 p-3">
            <p class="text-xs font-medium uppercase tracking-wide text-base-content/60">
              Zero Crossings
            </p>
            <p class="mt-1 text-2xl font-bold text-success">{List.last(@zero_crossings)}</p>
          </div>
        </div>
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
