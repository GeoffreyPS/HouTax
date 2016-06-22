defmodule Building.Cache do
	use GenServer

	def init(_) do
		{:ok, nil}
	end

	def start_link do
		IO.puts "Starting #{__MODULE__}"
		GenServer.start_link(__MODULE__, nil, name: :building_cache)
	end

	def server_process(building_id) do
		case Building.Server.where_is(building_id) do
			:undefined ->
				GenServer.call(:building_cache, {:server_process, building_id})
			pid -> pid
		end
	end

	def handle_call({:server_process, building_id}, _, state) do
		building_server_pid = case Building.Server.where_is(building_id) do
			:undefined -> 
				supervisor = :revolver.pid(:buildings_server_supervisors)
				{:ok, pid} = Building.ServerSupervisor.start_child(supervisor, building_id)
				pid

			pid -> pid
		end

		{:reply, building_server_pid, state}
	end
end