defmodule Building.Cache do
	use GenServer

	def init(_) do
		{:ok, Map.new}
	end

	def start do
		GenServer.start(__MODULE__, nil)
	end

	def server_process(cache_pid, building_id) do
		GenServer.call(cache_pid, {:server_process, building_id})
	end

	def handle_call({:server_process, building_id}, _, building_cache) do
		case Map.fetch(building_cache, building_id) do
			{:ok, building_pid} ->
				{:reply, building_pid, building_cache}

			:error ->
				{:ok, new_building} = Building.Server.start
				{
					:reply,
					new_building,
					Map.put(building_cache, building_id, new_building)
				}
		end
	end
end