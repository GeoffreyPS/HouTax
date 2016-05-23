defmodule TaxValue.DeltaFuns do
	@moduledoc"""
	Functions for calculating the annual delta and value delta for a TaxValue.
	"""
	@spec calc_value_delta(%TaxValue{}) :: %TaxValue{}
	def calc_value_delta(tax_value) when is_map(tax_value) do
		gross_value = Map.get(tax_value, :gross_value)
		taxed_value = Map.get(tax_value, :taxed_value)

		%{ tax_value | 
			value_delta: calc_value_delta(gross_value, taxed_value)
		}
	end

	@spec calc_value_delta(number, number) :: number
	defp calc_value_delta(gross_value, taxed_value) when is_number(gross_value) and is_number(taxed_value) do
	 gross_value - taxed_value
	end



	@spec calc_annual_deltas(%Building{}) :: %Building{}
	def calc_annual_deltas(building) when is_map(building) do
		%{Building | tax_values: calc_annual_deltas(Map.get(building, :tax_values))}
	end

	@spec calc_annual_deltas(%{integer => %TaxValue{}}) :: %{integer => %TaxValue{}}
	def calc_annual_deltas(tax_values) when is_map(tax_values) do
		years = 	Map.keys(tax_values) |> Enum.sort
		calc_annual_deltas(years, tax_values, %{})
	end

	@spec calc_annual_deltas(list[integer], %{integer => %TaxValue{}}, map) :: %{integer => %TaxValue{}}
	defp calc_annual_deltas([], _tax_values, state) do
		state
	end

	defp calc_annual_deltas(years, tax_values, state) when is_map(state) and map_size(state) == 0 do
		[first_year | _rest ] = years
		new_vals = %{state | first_year => tax_values[first_year] }
		calc_annual_deltas(years, tax_values, new_vals)
	end

	defp calc_annual_deltas(years, tax_values, state) do
		[previous_year, current_year | rest] = years
		new_vals = %{state | current_year => calc_annual_delta(tax_values[current_year], tax_values[previous_year])}
		calc_annual_deltas([current_year | rest], tax_values, new_vals)
	end

	@spec calc_annual_delta(%TaxValue{}, %TaxValue{}) :: %TaxValue{}
	defp calc_annual_delta(tax_value_current, tax_value_previous) do
		%{tax_value_current | 
			annual_delta: (tax_value_current[:taxed_value] - tax_value_previous[:taxed_value])
		}		
	end
end