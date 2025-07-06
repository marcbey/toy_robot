defmodule ToyRobot.Game.PlayerSupervisorTest do
  use ExUnit.Case, async: true

  alias ToyRobot.{Game.PlayerSupervisor, Robot}

  test "starts a player child process" do
    robot = %Robot{north: 0, east: 0, facing: :north}
    {:ok, player} = PlayerSupervisor.start_child(robot, "Robot 1")
    [{registered_player, _}] = Registry.lookup(ToyRobot.Game.PlayerRegistry, "Robot 1")
    assert registered_player == player
  end

  test "starts a registry" do
    registry = Process.whereis(ToyRobot.Game.PlayerRegistry)
    assert registry
  end

  test "moves a robot forward" do
    robot = %Robot{north: 0, east: 0, facing: :north}
    {:ok, _player} = PlayerSupervisor.start_child(robot, "Charlie")
    %{robot: %{north: north}} = PlayerSupervisor.move("Charlie")

    assert north == 1
  end
end
