defmodule BuildingHandler do
	use GenServer
	import Building
	import Deserializer

# Interface
	def put_row(pid, row), do: GenServer.cast(pid, {:put_row, row})

	def inspect(pid), do: GenServer.call(pid, {:inspect})

# Callbacks
	def init(_) do
		{:ok, Building.new}
	end


	def handle_call({:inspect}, _, building) do
		{:reply, IO.inspect(building), building}
	end

	def handle_cast({:put_row, row}, building) when is_map(row) do
		case building do
			%Building{id: nil} ->
				{:noreply, Building.new(row)}

			%Building{id: _} ->
				{:noreply, Building.add_tax_value(building, row)}
			end
	end

end