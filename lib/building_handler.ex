defmodule BuildingHandler do
	use GenServer
	import Building
	import Deserializer

	defmodule State do
		defstruct building: %Building{}
	end




# Callbacks
	def init([dispatcher, config]) when is_pid(dispatcher) do
		state = %State{building: %Building{}}
		init(config, state)
	end

	def init([], state) do
		{:ok, state}
	end

	def init([{:row, row} | rest], state) do
		%{state | building: Deserializer.building_with_value(row)}
		init(rest, state)
	end

	def init([_ | rest], state) do
		init(rest, state)
	end

	# def handle_call({:tax_value, row}) when is_map(row) do
	# 		tax_value = Deserializer.to_tax_value(row)
	# 		year = Deserializer.to_year(row)
	# 		Building.set_tax_year(, year, tax_value)
	# end

end