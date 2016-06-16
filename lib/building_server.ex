defmodule Building.Server do
	use GenServer

# Interface
	def start_link(building_id) do
		IO.puts "Starting #{__MODULE__}"
		GenServer.start_link(__MODULE__, building_id, name: via_tuple(building_id))
	end

	def put_row(pid, row), do: GenServer.cast(pid, {:put_row, row})

	def inspect(pid), do: GenServer.call(pid, {:inspect})

	def report(pid), do: GenServer.call(pid, {:report})

	def where_is(building_id) do
		:gproc.whereis_name({:n, :l, {:building_server, building_id}})
	end

# Callbacks
	def init(_) do
		{:ok, Building.new}
	end


	def handle_call({:inspect}, _, building) do
		{:reply, IO.inspect(building), building}
	end

	def handle_call({:report}, _, building) do
		new_building = Building.DeltaFuns.find_deltas(building)
		{:reply, new_building, new_building}
	end

	def handle_cast({:put_row, row}, building) when is_map(row) do
		case building do
			%Building{id: nil} ->
				{:noreply, Building.new(row)}

			%Building{id: _} ->
				state = building |> Building.add_tax_value(row) 
				{:noreply, state}
			end
	end

	def handle_info(_, state), do: {:noreply, state}

	defp via_tuple(building_id) do
		{:via, :gproc, {:n, :l, {:building_server, building_id}}}
	end

end