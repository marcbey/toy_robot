defmodule ToyRobot.Game.Player do
  use GenServer
  alias ToyRobot.{Table, Simulation}

  def start(position) do
    GenServer.start(__MODULE__, position)
  end

  def init(robot) do
    simulation = %Simulation{
      table: %Table{
        north_boundary: 4,
        east_boundary: 4
      },
      robot: robot
    }

    {:ok, simulation}
  end

  def move(pid) do
    GenServer.cast(pid, :move)
  end

  def report(pid) do
    GenServer.call(pid, :report)
  end

  def handle_call(:report, _from, simulation) do
    {:reply, simulation |> Simulation.report, simulation}
  end

  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = simulation |> Simulation.move
    {:noreply, new_simulation}
  end
end
