defmodule Building.ServerSupervisor do
	use Supervisor

	def start_link do
    Supervisor.start_link(__MODULE__, nil, name: :building_server_supervisor)
  end

  def start_child(building_id) do
    Supervisor.start_child(:building_server_supervisor, [building_id])
  end

  def init(_) do
    supervise([worker(Building.Server, [])], strategy: :simple_one_for_one)
  end
end