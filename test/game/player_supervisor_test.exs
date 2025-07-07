defmodule ToyRobot.Game.PlayerSupervisorTest do
  use ExUnit.Case, async: true

  alias ToyRobot.{Game.PlayerSupervisor, Robot, Table}

  test "starts a game child process" do
    table = %Table{north_boundary: 4, east_boundary: 4}
    robot = %Robot{north: 0, east: 0, facing: :north}
    {:ok, player} = PlayerSupervisor.start_child(table, robot, "Robot 1")
    [{registered_player, _}] = Registry.lookup(ToyRobot.Game.PlayerRegistry, "Robot 1")
    assert registered_player == player
  end

  test "starts a registry" do
    registry = Process.whereis(ToyRobot.Game.PlayerRegistry)
    assert registry
  end

  test "moves a robot forward" do
    table = %Table{north_boundary: 4, east_boundary: 4}
    robot = %Robot{north: 0, east: 0, facing: :north}
    {:ok, _player} = PlayerSupervisor.start_child(table, robot, "Charlie")
    %{robot: %{north: north}} = PlayerSupervisor.move("Charlie")

    assert north == 1
  end

  test "reports a robot's location" do
    table = %Table{north_boundary: 4, east_boundary: 4}
    robot = %{north: 0, east: 0, facing: :north}
    {:ok, _playe} = PlayerSupervisor.start_child(table, robot, "Davros")
    %{north: north} = PlayerSupervisor.report("Davros")

    assert north == 0
  end
end
