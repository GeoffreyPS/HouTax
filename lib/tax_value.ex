defmodule TaxValue do
	@typedoc"""
	Tax information for a given year; TaxValues belong to Buildings in its internal tax_values map and accessed with a key of its given year
	"""
	
	defstruct [
		:building_type, :gross_value, :taxed_value, 
		:value_delta, annual_delta: 0
	]

	@type t :: %TaxValue{	building_type: String.t, gross_value: number,
												taxed_value: number, value_delta: number, annual_delta: number } 
end
