defmodule ToyRobot.Game.Player do
  use GenServer
  alias ToyRobot.{Robot, Simulation}

  @type t :: {:via, Registry, {ToyRobot.Game.PlayerRegistry, atom()}}

  @doc """
  Starts a new player process with the given robot position.
  Returns {:ok, pid} on success.
  """
  def start(table, position) do
    GenServer.start(__MODULE__, [table: table, position: position])
  end

  @doc """
  This start_link/1 function is the one that our supervisor will call when we call DynamicSupervisor.start_child/2.
  In this function, we use GenServer.start_link/2 and this will indicate to Elixir that we’re starting a linked process.
  Returns {:ok, pid} on success.
  """
  def start_link(table: table, position: position, name: name) do
    GenServer.start_link(__MODULE__, [table: table, position: position], name: process_name(name))
  end

  def process_name(name) do
    {:via, Registry, {ToyRobot.Game.PlayerRegistry, name}}
  end

  @impl true
  def init([table: table, position: position]) do
    simulation = %Simulation{
      table: table,
      robot: position
    }

    {:ok, simulation}
  end

  # Will be invoked when we make a call to this GenServer via the GenServer.call/2
  # We do not call this function directly ourselves, but instead it is called by some internal Elixir code
  # The first return element indicates that the GenServer will issue a reply back to the
  # thing that called GenServer.call. The 2nd element is what we're going to give back as a return value when
  # GenServer.call runs. The 3rd element is the state of the GenServer, which can change after a call, but it won't
  # this time around.
  @impl true
  def handle_call(:report, _from, simulation) do
    {:reply, simulation |> Simulation.report(), simulation}
  end

  # Will be invoked when we make a call to this GenServer via the GenServer.cast/2
  # The actual work happens asynchronously in handle_cast/3.
  # A cast message is one that is sent to the GenServer and we would use it in cases where we do not expect a reply.
  @impl true
  def handle_cast(:move, simulation) do
    {:ok, new_simulation} = simulation |> Simulation.move()
    {:noreply, new_simulation}
  end

  @doc """
  Asynchronously moves the robot forward one space.
  Always returns :ok immediately (fire-and-forget).
  The actual movement happens asynchronously inside the GenServer.
  """
  @spec move(t()) :: :ok
  def move(process_name) do
    # Does not block the calling process
    # Always returns :ok immediately
    # Used when you don't need a response back
    GenServer.cast(process_name, :move)
  end

  @doc """
  Synchronously gets the current robot position.
  Blocks until the GenServer responds with the robot's current state.
  """
  @spec report(t()) :: %Robot{}
  def report(process_name) do
    # Blocks the calling process until the GenServer responds
    # Returns the actual value from the GenServer
    # Used when you need a response back
    GenServer.call(process_name, :report)
  end
end
