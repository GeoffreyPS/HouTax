defmodule Building.Server do
	use GenServer

# Interface
	def start, do: GenServer.start(__MODULE__, nil)

	def put_row(pid, row), do: GenServer.cast(pid, {:put_row, row})

	def inspect(pid), do: GenServer.call(pid, {:inspect})

	def report(pid), do: GenServer.call(pid, {:report})

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
end