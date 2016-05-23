defmodule TaxValue do
	
	defstruct [
		:building_type, :gross_value, :taxed_value, 
		:value_delta, annual_delta: 0
	]

	@type t :: %TaxValue{	building_type: String.t, gross_value: number,
												taxed_value: number, value_delta: number, annual_delta: number } 
end
