defmodule ToyRobot.CommandRunner do
  alias ToyRobot.{Simulation, Table}

  def run([{:place, placement} | rest]) do
    table = %Table{north_boundary: 4, east_boundary: 4}

    case Simulation.place(table, placement) do
      {:ok, simulation} -> run(rest, simulation)
      {:error, :invalid_placement} -> run(rest)
    end
  end

  def run([_command | rest]), do: run(rest)

  def run([]), do: nil

  def run([:move | rest], simulation) do
    new_simulation =
      simulation
      |> Simulation.move()
      |> case do
        {:ok, moved_simulation} -> moved_simulation
        {:error, :at_table_boundary} -> simulation
      end

    run(rest, new_simulation)
  end

  def run([:move_2 | rest], simulation) do
    new_simulation =
      simulation
      |> Simulation.move_2()
      |> case do
        {:ok, moved_simulation} -> moved_simulation
        {:error, :at_table_boundary} -> simulation
      end

    run(rest, new_simulation)
  end

  def run([], simulation), do: simulation

  def run([:turn_left | rest], simulation) do
    {:ok, simulation} = simulation |> Simulation.turn_left()
    run(rest, simulation)
  end

  def run([:turn_right | rest], simulation) do
    {:ok, simulation} = simulation |> Simulation.turn_right()
    run(rest, simulation)
  end

  def run([:uturn | rest], simulation) do
    {:ok, simulation} = simulation |> Simulation.uturn()
    run(rest, simulation)
  end

  def run([:report | rest], simulation) do
    %{
      east: east,
      north: north,
      facing: facing
    } = Simulation.report(simulation)

    facing = facing |> Atom.to_string() |> String.upcase()
    IO.puts("The robot is at (#{east}, #{north}) and is facing #{facing}")

    run(rest, simulation)
  end

  def run([{:invalid, _invalid_command} | rest], simulation) do
    run(rest, simulation)
  end
end
