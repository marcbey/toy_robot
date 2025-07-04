defmodule ToyRobot.Simulation do
  alias ToyRobot.{Robot, Table}
  defstruct [:table, :robot]
  alias __MODULE__, as: Simulation

  @doc """
  Simulates placing a robot on a table.

  ## Examples

  ### When the robot is placed in a valid position:

  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> Simulation.place(table, %{north: 0, east: 0, facing: :north})
  {
    :ok,
    %Simulation{
      table: table,
      robot: %Robot{north: 0, east: 0, facing: :north}
    }
   }

  ### When the robot is placed in an invalid position:

  iex> alias ToyRobot.{Table, Simulation}
  [ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> Simulation.place(table, %{north: 6, east: 0, facing: :north})
  {:error, :invalid_placement}
  """
  def place(table, placement) do
    if Table.valid_position?(table, placement) do
      {
        :ok,
        %__MODULE__{
          table: table,
          robot: struct(Robot, placement)
        }
      }
    else
      {:error, :invalid_placement}
    end
  end

  @doc """
  Moves the robot forward one space in the direction that it is facing, unless that position is past the boundaries of the table.


  ## Examples

  ### A valid movement

  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
  iex> simulation |> Simulation.move
  {:ok, %Simulation{table: table, robot: %Robot{north: 1, east: 0, facing: :north}}}

  ### An invalid movement
  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{
  ...>   table: table,
  ...>   robot: %Robot{north: 4, east: 0, facing: :north}
  ...> }
  iex> simulation |> Simulation.move()
  {:error, :at_table_boundary}
  """
  def move(%Simulation{robot: robot, table: table} = simulation) do
    with moved_robot <- robot |> Robot.move(),
         true <- table |> Table.valid_position?(moved_robot) do
      {:ok, %{simulation | robot: moved_robot}}
    else
      false -> {:error, :at_table_boundary}
    end
  end

  @doc """
  Moves the robot forward two spaces in the direction it is facing.

  ## Examples

  ### A valid movement

  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{table: table, robot: %Robot{north: 0, east: 0, facing: :north}}
  iex> simulation |> Simulation.move_2
  {:ok, %Simulation{table: table, robot: %Robot{north: 2, east: 0, facing: :north}}}

  ### An invalid movement
  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{
  ...>   table: table,
  ...>   robot: %Robot{north: 4, east: 0, facing: :north}
  ...> }
  iex> simulation |> Simulation.move_2()
  {:error, :at_table_boundary}
  """
  def move_2(%Simulation{robot: robot, table: table} = simulation) do
    with moved_robot <- robot |> Robot.move_2(),
         true <- table |> Table.valid_position?(moved_robot) do
      {:ok, %{simulation | robot: moved_robot}}
    else
      false -> {:error, :at_table_boundary}
    end
  end

  @doc """
  Turns the robot left.

  ## Examples

  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{
  ...>   table: table,
  ...>   robot: %Robot{north: 0, east: 0, facing: :north}
  ...> }
  iex> simulation |> Simulation.turn_left()
  {:ok, %Simulation{table: table,robot: %Robot{north: 0, east: 0, facing: :west}}}
  """
  def turn_left(%Simulation{robot: robot} = simulation) do
    turned_robot = Robot.turn_left(robot)
    {:ok, %{simulation | robot: turned_robot}}
  end

  @doc """
  Turns the robot right.

  ## Examples

  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{
  ...>   table: table,
  ...>   robot: %Robot{north: 0, east: 0, facing: :north}
  ...> }
  iex> simulation |> Simulation.turn_right()
  {:ok, %Simulation{table: table,robot: %Robot{north: 0, east: 0, facing: :east}}}
  """
  def turn_right(%Simulation{robot: robot} = simulation) do
    turned_robot = Robot.turn_right(robot)
    {:ok, %{simulation | robot: turned_robot}}
  end

  @doc """
  Turns the robot around 180 degrees.

  ## Examples

  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{
  ...>   table: table,
  ...>   robot: %Robot{north: 0, east: 0, facing: :north}
  ...> }
  iex> simulation |> Simulation.uturn()
  {:ok, %Simulation{table: table,robot: %Robot{north: 0, east: 0, facing: :south}}}
  """
  def uturn(%Simulation{robot: robot} = simulation) do
    turned_robot = Robot.uturn(robot)
    {:ok, %{simulation | robot: turned_robot}}
  end

  @doc """
  Returns the robot's current position.

  ## Examples

  iex> alias ToyRobot.{Robot, Table, Simulation}
  [ToyRobot.Robot, ToyRobot.Table, ToyRobot.Simulation]
  iex> table = %Table{north_boundary: 4, east_boundary: 4}
  %Table{north_boundary: 4, east_boundary: 4}
  iex> simulation = %Simulation{
  ...>   table: table,
  ...>   robot: %Robot{north: 0, east: 0, facing: :north}
  ...> }
  iex> simulation |> Simulation.report()
  %Robot{north: 0, east: 0, facing: :north}
  """
  def report(%Simulation{robot: robot}), do: robot
end
