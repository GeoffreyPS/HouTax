defmodule TaxValue.DeltaFuns do
	@moduledoc"""
	Functions for calculating the annual delta and value delta for a TaxValue.
	"""
	@doc"""
	Accepts a Building struct and returns a new Building with all tax values updated
	"""
	@spec find_deltas(%Building{}) :: %Building{}
	def find_deltas(building), do: building |> find_value_deltas |> find_annual_deltas

	@doc"""
	Accepts a Building struct and returns a new Building with updated value_deltas for each tax year in :tax_values
	"""
	@spec find_value_deltas(%Building{}) :: %Building{}
	def find_value_deltas(building) when is_map(building) do
		%Building{tax_values: tax_values}	= building
		%Building{building | tax_values: calc_value_deltas tax_values}	
	end

	@spec calc_value_deltas(%{integer => %TaxValue{}}) :: %{integer => %TaxValue{}}
	defp calc_value_deltas(tax_values) do
		years = Map.keys(tax_values)
		Enum.reduce(years, %{}, fn(year, acc) -> Map.put_new(acc, year, calc_value_delta(tax_values[year])) end ) 
	end

	@doc"""
	Sets the Value Delta for a TaxValue within a single year. 
	"""
	@spec calc_value_delta(%TaxValue{}) :: %TaxValue{}
	def calc_value_delta(tax_value) when is_map(tax_value) do
		%TaxValue{gross_value: gross_value, taxed_value: taxed_value} = tax_value

		%TaxValue{ tax_value | value_delta: gross_value - taxed_value }
	end


	@doc"""
	Accepts a Building struct that contains nested TaxValue structs and returns Building with Annual Delta fields calcualted.
	"""
	@spec find_annual_deltas(%Building{}) :: %Building{}
	def find_annual_deltas(building) when is_map(building) do
		%Building{tax_values: tax_values} = building

		%Building{building | tax_values: calc_annual_deltas tax_values}
	end

	@spec calc_annual_deltas(%{integer => %TaxValue{}}) :: %{integer => %TaxValue{}}
	defp calc_annual_deltas(tax_values) when is_map(tax_values) do
		years = Map.keys(tax_values) |> Enum.sort
		calc_annual_deltas(years, tax_values, %{})
	end

	@spec calc_annual_deltas(list[integer], map, %{integer => %TaxValue{}}) :: %{integer => %TaxValue{}}
	defp calc_annual_deltas([], _tax_values, state) do
		state
	end

	defp calc_annual_deltas([first_year | rest], tax_values, state) when 
	 is_map(state) and map_size(state) == 0 do
		new_state = Map.put_new(state, first_year, tax_values[first_year])
		calc_annual_deltas([first_year | rest], tax_values, new_state)
	end

	defp calc_annual_deltas([previous_year, current_year | []], tax_values, state) do
		new_tax = calc_annual_delta(tax_values[current_year], tax_values[previous_year])
		new_state = Map.put_new(state, current_year, new_tax)
		calc_annual_deltas([], tax_values, new_state)
	end

	defp calc_annual_deltas([previous_year, current_year | rest], tax_values, state) do
		new_tax = calc_annual_delta(tax_values[current_year], tax_values[previous_year])
		new_state = Map.put_new(state, current_year, new_tax)
		calc_annual_deltas([current_year | rest], tax_values, new_state)
	end

	@spec calc_annual_delta(%TaxValue{}, %TaxValue{}) :: %TaxValue{}
	defp calc_annual_delta(tax_value_current, tax_value_previous) when 
	is_map(tax_value_current) and is_map(tax_value_previous) do
		
		%TaxValue{taxed_value: current_tv} = tax_value_current
		%TaxValue{taxed_value: previous_tv} = tax_value_previous 
		%TaxValue{ tax_value_current | annual_delta: (current_tv - previous_tv) }		
	end
end