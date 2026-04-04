defmodule AocExWeb.PuzzleLive.Form do
  use AocExWeb, :live_view

  alias AocEx.Puzzles
  alias AocEx.Puzzles.Puzzle

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage puzzle records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="puzzle-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:year]} type="number" label="Year" />
        <.input field={@form[:day]} type="number" label="Day" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:example]} type="textarea" label="example" />
        <.input field={@form[:part1]} type="textarea" label="Part1" />
        <.input field={@form[:part2]} type="textarea" label="Part2" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Puzzle</.button>
          <.button navigate={return_path(@return_to, @puzzle)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    puzzle = Puzzles.get_puzzle!(id)

    socket
    |> assign(:page_title, "Edit Puzzle")
    |> assign(:puzzle, puzzle)
    |> assign(:form, to_form(Puzzles.change_puzzle(puzzle)))
  end

  defp apply_action(socket, :new, _params) do
    puzzle = %Puzzle{}

    socket
    |> assign(:page_title, "New Puzzle")
    |> assign(:puzzle, puzzle)
    |> assign(:form, to_form(Puzzles.change_puzzle(puzzle)))
  end

  @impl true
  def handle_event("validate", %{"puzzle" => puzzle_params}, socket) do
    changeset = Puzzles.change_puzzle(socket.assigns.puzzle, puzzle_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"puzzle" => puzzle_params}, socket) do
    save_puzzle(socket, socket.assigns.live_action, puzzle_params)
  end

  defp save_puzzle(socket, :edit, puzzle_params) do
    case Puzzles.update_puzzle(socket.assigns.puzzle, puzzle_params) do
      {:ok, puzzle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Puzzle updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, puzzle))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_puzzle(socket, :new, puzzle_params) do
    case Puzzles.create_puzzle(puzzle_params) do
      {:ok, puzzle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Puzzle created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, puzzle))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _puzzle), do: ~p"/puzzles"
  defp return_path("show", puzzle), do: ~p"/puzzles/#{puzzle}"
end
