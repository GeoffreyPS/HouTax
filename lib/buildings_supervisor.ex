defmodule Buildings.Supervisor do
	use Supervisor

	def start_link do
		IO.puts "Starting #{__MODULE__}"
		Supervisor.start_link(__MODULE__, nil, name: :buildings_supervisor)
	end

	def init(_) do
		processes = [
			supervisor(Building.ServerSupervisor, []),
			worker(Building.Cache, [])
		]
		supervise(processes, strategy: :one_for_one)
	end
end