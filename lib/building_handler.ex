defmodule BuildingHandler do
	use GenServer
	import Building
	import Deserializer

	defmodule State do
		defstruct[:building]
	end




# Callbacks
	def init([dispatcher, config]) when is_pid(dispatcher) do
		state = %State{}
		init([config], state)
	end

	def init([], state) do
		{:ok, state}
	end

	def init([row: row, year: year | rest], state) do
		%{state | building: Deserializer.building_with_value(csv_row, year)}
		init(rest, state)
	end

	def init([_ | rest], state) do
		init(rest, state)
	end

	def handle_call({:tax_value, year, row}) when is_integer(year) and when is_map(row) do
			Deserializer.to_tax_value(row)
			Building.set_tax_year(state, row, year)
	end

end