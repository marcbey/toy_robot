defmodule ToyRobot.Robot do
  defstruct north: 0, east: 0, facing: :north
  alias __MODULE__, as: Robot

  @doc """
  Moves the robot forward one space in the direction it is facing.
  ## Examples

  iex> alias ToyRobot.Robot
  ToyRobot.Robot
  iex> robot = %Robot{north: 0, facing: :north}
  %Robot{north: 0, east: 0, facing: :north}
  iex> robot |> Robot.move
  %Robot{north: 1, east: 0, facing: :north}
  """
  def move(%Robot{} = robot) do
    case robot.facing do
      :north -> robot |> move_north
      :east -> robot |> move_east
      :south -> robot |> move_south
      :west -> robot |> move_west
    end
  end

  @doc """
   Turns the robot left.

   ## Examples

   iex> alias ToyRobot.Robot
   ToyRobot.Robot
   iex> robot = %Robot{facing: :north}
   %Robot{facing: :north}
   iex> robot |> Robot.turn_left
   %Robot{facing: :west}
  """
  def turn_left(%Robot{} = robot) do
    case robot.facing do
      :north -> %{robot | facing: :west}
      :east -> %{robot | facing: :north}
      :south -> %{robot | facing: :east}
      :west -> %{robot | facing: :south}
    end
  end

  @doc """
  Turns the robot right.

  ## Examples

  iex> alias ToyRobot.Robot
  ToyRobot.Robot
  iex> robot = %Robot{facing: :north}
  %Robot{facing: :north}
  iex> robot |> Robot.turn_right
  %Robot{facing: :east}
  """
  def turn_right(%Robot{} = robot) do
    case robot.facing do
      :north -> %{robot | facing: :east}
      :east -> %{robot | facing: :south}
      :south -> %{robot | facing: :west}
      :west -> %{robot | facing: :north}
    end
  end

  @doc """
  Moves the robot forward one space in the direction it is facing.
  ## Examples

  iex> alias ToyRobot.Robot
  ToyRobot.Robot
  iex> robot = %Robot{east: 0}
  %Robot{north: 0, east: 0, facing: :north}
  iex> robot |> Robot.move_east
  %Robot{north: 0, east: 1, facing: :north}
  iex> robot |> Robot.move_east |> Robot.move_east |> Robot.move_east
  %Robot{north: 0, east: 3, facing: :north}
  """
  def move_east(%Robot{} = robot) do
    %{robot | east: robot.east + 1}
  end

  @doc """
  Moves the robot west one space.

  ## Examples

  iex> alias ToyRobot.Robot
  ToyRobot.Robot
  iex> robot = %Robot{east: 0}
  %Robot{north: 0, east: 0, facing: :north}
  iex> robot |> Robot.move_west
  %Robot{north: 0, east: -1, facing: :north}
  iex> robot |> Robot.move_west |> Robot.move_west |> Robot.move_west
  %Robot{north: 0, east: -3, facing: :north}
  """
  def move_west(%Robot{} = robot) do
    %{robot | east: robot.east - 1}
  end

  @doc """
  Moves the robot north one space.

  ## Examples

  iex> alias ToyRobot.Robot
  ToyRobot.Robot
  iex> robot = %Robot{north: 0}
  %Robot{north: 0, east: 0, facing: :north}
  iex> robot |> Robot.move_north
  %Robot{north: 1, east: 0, facing: :north}
  iex> robot |> Robot.move_north |> Robot.move_north |> Robot.move_north
  %Robot{north: 3, east: 0, facing: :north}
  """
  def move_north(%Robot{} = robot) do
    %{robot | north: robot.north + 1}
  end

  @doc """
  Moves the robot south one space.

  ## Examples

  iex> alias ToyRobot.Robot
  ToyRobot.Robot
  iex> robot = %Robot{north: 0}
  %Robot{north: 0, east: 0, facing: :north}
  iex> robot |> Robot.move_south
  %Robot{north: -1, east: 0, facing: :north}
  iex> robot |> Robot.move_south |> Robot.move_south |> Robot.move_south
  %Robot{north: -3, east: 0, facing: :north}
  """
  def move_south(%Robot{} = robot) do
    %{robot | north: robot.north - 1}
  end

  @doc """
  Turns the robot around 180 degrees.

  ## Examples

  iex> alias ToyRobot.Robot
  ToyRobot.Robot
  iex> robot = %Robot{facing: :north}
  %Robot{facing: :north}
  iex> robot |> Robot.uturn
  %Robot{facing: :south}
  """
  def uturn(%Robot{} = robot) do
    case robot.facing do
      :north -> %{robot | facing: :south}
      :east -> %{robot | facing: :west}
      :south -> %{robot | facing: :north}
      :west -> %{robot | facing: :east}
    end
  end
end
