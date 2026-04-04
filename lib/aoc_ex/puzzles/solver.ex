defmodule AocEx.Puzzles.Solver do
  @moduledoc """
  Loads and evaluates the solver module associated with a puzzle.

  Solver modules are expected under `AocEx.Solutions` and should follow this
  naming convention:

      defmodule AocEx.Solutions.Y2026.Day05 do
        def part1, do: 123
        def part2, do: 456
      end

  The loader also accepts a `solve/0` function returning either:

    * `%{part1: ..., part2: ...}`
    * `%{"part1" => ..., "part2" => ...}`
    * `{part1, part2}`
  """

  require Logger
  alias AocEx.Puzzles.Puzzle

  @type status :: :solved | :missing | :error

  @type t :: %{
          status: status(),
          module: module(),
          file_path: String.t(),
          part1: String.t() | nil,
          part2: String.t() | nil,
          error: String.t() | nil
        }

  @spec for_puzzle(Puzzle.t()) :: t()
  def for_puzzle(%Puzzle{} = puzzle) do
    module = module_for(puzzle)
    file_path = file_path_for(puzzle)

    case Code.ensure_loaded(module) do
      {:module, ^module} -> run_solver(module, file_path)
      {:error, _reason} -> missing_result(module, file_path)
    end
  end

  @spec module_for(Puzzle.t()) :: module()
  def module_for(%Puzzle{year: year, day: day}) do
    Module.concat([AocEx.Solutions, "Y#{year}", "Day#{pad_day(day)}"])
  end

  @spec file_path_for(Puzzle.t()) :: String.t()
  def file_path_for(%Puzzle{year: year, day: day}) do
    Path.join([
      "lib",
      "aoc_ex",
      "solutions",
      "y#{year}",
      "day#{pad_day(day)}.ex"
    ])
  end

  defp run_solver(module, file_path) do
    try do
      {part1, part2} = extract_parts(module)

      %{
        status: :solved,
        module: module,
        file_path: file_path,
        part1: format_value(part1),
        part2: format_value(part2),
        error: nil
      }
    rescue
      error ->
        %{
          status: :error,
          module: module,
          file_path: file_path,
          part1: nil,
          part2: nil,
          error: Exception.message(error)
        }
    catch
      kind, reason ->
        %{
          status: :error,
          module: module,
          file_path: file_path,
          part1: nil,
          part2: nil,
          error: Exception.format_banner(kind, reason)
        }
    end
  end

  defp extract_parts(module) do
    cond do
      function_exported?(module, :solve, 0) ->
        normalize_solve_result(module.solve())

      function_exported?(module, :part1, 0) and function_exported?(module, :part2, 0) ->
        {module.part1(), module.part2()}

      true ->
        raise ArgumentError,
              "solver must define solve/0 or both part1/0 and part2/0"
    end
  end

  defp normalize_solve_result({part1, part2}), do: {part1, part2}
  defp normalize_solve_result(%{part1: part1, part2: part2}), do: {part1, part2}
  defp normalize_solve_result(%{"part1" => part1, "part2" => part2}), do: {part1, part2}

  defp normalize_solve_result(result) do
    raise ArgumentError,
          "unsupported solve/0 return value: #{inspect(result, pretty: true, limit: :infinity)}"
  end

  defp format_value(value) when is_binary(value), do: value
  defp format_value(value), do: inspect(value, pretty: true, limit: :infinity)

  defp missing_result(module, file_path) do
    %{
      status: :missing,
      module: module,
      file_path: file_path,
      part1: nil,
      part2: nil,
      error: nil
    }
  end

  def pad_day(day) do
    day
    |> Integer.to_string()
    |> String.pad_leading(2, "0")
  end
end
