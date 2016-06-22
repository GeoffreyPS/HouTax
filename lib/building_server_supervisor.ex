defmodule Building.ServerSupervisor do
	use Supervisor

	def start_link(supervisor_id) do
    Supervisor.start_link(__MODULE__, nil, name: via_tuple(supervisor_id))
  end

  def start_child(pid, building_id) when is_pid(pid) do
    Supervisor.start_child(pid, [building_id])
  end

  def init(_) do
    supervise([worker(Building.Server, [])], strategy: :simple_one_for_one)
  end

  defp via_tuple(supervisor_id) do
    {:via, :gproc, {:n, :l, {:building_server_supervisors, supervisor_id}}}
  end

end