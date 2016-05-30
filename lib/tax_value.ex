defmodule TaxValue do
	@moduledoc"""
	Tax information for a given year; TaxValues belong to Buildings in its internal tax_values map and accessed with a key of its given year
	"""
	
	defstruct [
		:building_type, :gross_value, :taxed_value, 
		:value_delta, annual_delta: 0
	]

	@type t :: %TaxValue{	building_type: String.t, gross_value: number,
												taxed_value: number, value_delta: number, annual_delta: number } 

	@doc"""
	Convenience function for accessing a TaxValue's building type
	"""
	@spec building_type(%TaxValue{}) :: String.t
	def building_type(%TaxValue{building_type: building_type}), do: building_type

	@doc"""
	Convenience function for accessing a TaxValue's building type
	"""
	@spec gross_value(%TaxValue{}) :: number
	def gross_value(%TaxValue{gross_value: gross_value}), do: gross_value

	@doc"""
	Convenience function for accessing a TaxValue's building type
	"""
	@spec taxed_value(%TaxValue{}) :: number
	def taxed_value(%TaxValue{taxed_value: taxed_value}), do: taxed_value

	@doc"""
	Convenience function for accessing a TaxValue's building type
	"""
	@spec value_delta(%TaxValue{}) :: number
	def value_delta(%TaxValue{value_delta: value_delta}), do: value_delta

	@doc"""
	Convenience function for accessing a TaxValue's building type
	"""
	@spec annual_delta(%TaxValue{}) :: number
	def annual_delta(%TaxValue{annual_delta: annual_delta}), do: annual_delta
end
