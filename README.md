# ToyRobot

A Toy Robot Simulator implemented in Elixir. This project simulates a robot that can be placed on a table and given commands to move, turn, and report its position.

## Features

- **Place**: Place the robot on a table at a specific position and facing direction
- **Move**: Move the robot one unit in the direction it's facing (if within table boundaries)
- **Turn**: Rotate the robot left or right (90 degrees)
- **Report**: Get the current position and facing direction of the robot
- **Command Interpretation**: Parse string commands into executable actions
- **Boundary Validation**: Prevent the robot from falling off the table

## Table and Robot

The simulation uses a table with configurable boundaries (default 5x5 grid, coordinates 0-4) and a robot that can face four directions:
- `:north` - facing up
- `:east` - facing right  
- `:south` - facing down
- `:west` - facing left

## Commands

The robot accepts the following commands:

- `PLACE X,Y,FACING` - Place the robot at position (X,Y) facing the specified direction
  - Example: `PLACE 1,2,NORTH`
- `MOVE` - Move the robot one unit forward in the direction it's facing
- `LEFT` - Turn the robot 90 degrees to the left
- `RIGHT` - Turn the robot 90 degrees to the right
- `REPORT` - Report the robot's current position and facing direction

## Usage

### Basic Example

```elixir
alias ToyRobot.{Table, Simulation, CommandInterpreter}

# Create a 5x5 table
table = %Table{north_boundary: 4, east_boundary: 4}

# Define commands
commands = ["PLACE 1,2,NORTH", "MOVE", "LEFT", "REPORT"]

# Interpret commands
interpreted_commands = CommandInterpreter.interpret(commands)

# Place the robot and execute commands
{:ok, simulation} = Simulation.place(table, %{north: 1, east: 2, facing: :north})

# Execute the interpreted commands...
```

### Command Interpretation

```elixir
commands = ["PLACE 1,2,NORTH", "MOVE", "LEFT", "RIGHT", "REPORT"]
CommandInterpreter.interpret(commands)
# Returns:
# [
#   {:place, %{north: 2, east: 1, facing: :north}},
#   :move,
#   :turn_left,
#   :turn_right,
#   :report
# ]
```

### Simulation Operations

```elixir
# Place a robot
{:ok, simulation} = Simulation.place(table, %{north: 0, east: 0, facing: :north})

# Move the robot
{:ok, simulation} = Simulation.move(simulation)

# Turn the robot
{:ok, simulation} = Simulation.turn_left(simulation)
{:ok, simulation} = Simulation.turn_right(simulation)

# Get robot position
robot = Simulation.report(simulation)
# Returns: %Robot{north: 1, east: 0, facing: :west}
```

## Project Structure

- `ToyRobot.Table` - Represents the table with boundaries
- `ToyRobot.Robot` - Represents the robot with position and facing direction
- `ToyRobot.Simulation` - Manages the robot-table interaction and movement logic
- `ToyRobot.CommandInterpreter` - Parses string commands into executable actions

## Testing

Run the test suite:

```bash
mix test
```

The project includes comprehensive doctests that serve as both documentation and test cases.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `toy_robot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:toy_robot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/toy_robot>.

