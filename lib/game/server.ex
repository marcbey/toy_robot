defmodule ToyRobot.Game.Server do
  use GenServer

  alias ToyRobot.Table
  alias ToyRobot.Game.PlayerSupervisor

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(north_boundary: north_boundary, east_boundary: east_boundary) do
    registry_id = "game-#{UUID.uuid4()}" |> String.to_atom()
    Registry.start_link(keys: :unique, name: registry_id)

    {:ok,
     %{
      registry_id: registry_id,
       table: %Table{
         north_boundary: north_boundary,
         east_boundary: east_boundary
       },
       players: %{}
     }}
  end

  def handle_call({:place, position, name}, _from, %{table: table, players: players} = state) do
    {:ok, player} = PlayerSupervisor.start_child(table, position, name)
    players = players |> Map.put(name, player)
    {:reply, :ok, %{state | players: players}}
  end

  def handle_call(:player_count, _from, %{players: players} = state) do
    {:reply, map_size(players), state}
  end

  def place(game, position, name) do
    GenServer.call(game, {:place, position, name})
  end

  def player_count(game) do
    GenServer.call(game, :player_count)
  end
end
