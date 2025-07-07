defmodule ToyRobot.Game.Player do
  use GenServer
  alias ToyRobot.{Table, Simulation, Robot}

  @type t :: pid()

  @doc """
  Starts a new player process with the given robot position.
  Returns {:ok, pid} on success.
  """
  @spec start(%Robot{}) :: {:ok, t()}
  def start(position) do
    GenServer.start(__MODULE__, position)
  end

  @doc """
  Starts a new player process linked to the current process with the given robot and name.
  Returns {:ok, pid} on success.
  """
  @spec start_link(robot: %Robot{}, name: atom()) :: {:ok, t()}
  def start_link(robot: robot, name: name) do
    GenServer.start_link(__MODULE__, robot, name: process_name(name))
  end

  def process_name(name) do
    {:via, Registry, {ToyRobot.Game.PlayerRegistry, name}}
  end

  @impl true
  def init(robot) do
    simulation = %Simulation{
      table: %Table{
        north_boundary: 4,
        east_boundary: 4
      },
      robot: robot
    }

    # Second argument is the initial state for the GenServer
    {:ok, simulation}
  end

  @doc """
  Asynchronously moves the robot forward one space.
  Always returns :ok immediately (fire-and-forget).
  The actual movement happens asynchronously inside the GenServer.
  """
  @spec move(t()) :: :ok
  def move(pid) do
    # Does not block the calling process
    # Always returns :ok immediately
    # Used when you don't need a response back
    GenServer.cast(pid, :move)
  end

  @doc """
  Synchronously gets the current robot position.
  Blocks until the GenServer responds with the robot's current state.
  """
  @spec report(t()) :: %Robot{}
  def report(pid) do
    # Blocks the calling process until the GenServer responds
    # Returns the actual value from the GenServer
    #Used when you need a response back
    GenServer.call(pid, :report)
  end

  # Will be invoked when we make a call to this GenServer via the GenServer.call/2
  # We do not call this function directly ourselves, but instead it is called by some internal Elixir code
  # The first return element indicates that the GenServer will issue a reply back to the
  # thing that called GenServer.call. The 2nd element is what we're going to give back as a return value when
  # GenServer.call runs. The 3rd element is the state of the GenServer, which can change after a call, but it won't
  # this time around.
  @impl true
  def handle_call(:report, _from, simulation) do
    {:reply, simulation |> Simulation.report, simulation}
  end

  # Will be invoked when we make a call to this GenServer via the GenServer.cast/2
  # The actual work happens asynchronously in handle_cast/3.
  # A cast message is one that is sent to the GenServer and we would use it in cases where we do not expect a reply.
  @impl true
  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = simulation |> Simulation.move
    {:noreply, new_simulation}
  end
end
