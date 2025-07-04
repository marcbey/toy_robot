defmodule ToyRobot.Game.Player do
  use GenServer
  alias ToyRobot.Robot

  def start(position) do
    GenServer.start(__MODULE__, position)
  end

  def init(robot) do
    {:ok, robot}
  end

  def move(pid) do
    GenServer.cast(pid, :move)
  end

  def report(pid) do
    GenServer.call(pid, :report)
  end

  def handle_call(:report, _from, robot) do
    {:reply, robot, robot}
  end

  def handle_cast(:move, robot) do
    {:noreply, robot |> Robot.move()}
  end
end
