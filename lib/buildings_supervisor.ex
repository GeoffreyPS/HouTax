defmodule Buildings.Supervisor do
	use Supervisor

	def start_link(pool_size \\ 20) do
		Supervisor.start_link(__MODULE__, {pool_size}, name: :buildings_supervisor)
	end

	def init({pool_size}) do
		processes = for supervisor_id <- 1..pool_size do
			supervisor(Building.ServerSupervisor, [supervisor_id], id: {:building_server_supervisors, supervisor_id})
		end
		
		:revolver.balance(:buildings_supervisor, :buildings_server_supervisors)
		supervise(processes, strategy: :one_for_one)
	end
end