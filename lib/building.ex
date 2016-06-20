defmodule Building do
	@moduledoc"""
	Serves as the main data structure for a given address. tax_values holds a map of TaxValues with years as a key.
	"""

	defstruct [
		:id, :street_number, :street_name,
		:city, :zip, tax_values: %{}
	]

	@type t :: %Building{id: String.t, street_number: integer, street_name: String.t, 
											city: String.t, zip: integer, tax_values: %{String.t => TaxValue}}

	@doc"""
	Initializes a new building with a CSV row. If given no arguments, a blank building struct will return.
	""" 	
	def new, do: %Building{}

	@spec new(%{}) :: %Building{}
	def new(csv_map) when is_map(csv_map) do
		Deserializer.building_with_value(csv_map)
	end

	@doc"""
	Convenience function for retreiving a Building's id
	"""
	@spec id(%Building{}) :: integer
	def id(%Building{id: id}), do: id

	@doc"""
	Convenience function for retreiving a Building's street number
	"""
	@spec street_number(%Building{}) :: integer
	def street_number(%Building{street_number: street_number}), do: street_number

	@doc"""
	Convenience function for retreiving a Building's street name
	"""
	@spec street_name(%Building{}) :: String.t
	def street_name(%Building{street_name: street_name}), do: street_name

	@doc"""
	Convenience function for retreiving a Building's city
	"""
	@spec city(%Building{}) :: String.t
	def city(%Building{city: city}), do: city

	@doc"""
	Convenience function for retreiving a Building's zip code
	"""
	@spec zip(%Building{}) :: Integer
	def zip(%Building{zip: zip}), do: zip

	@doc"""
	Convenience function for retreiving a Building's tax_values.
	Returns a Map of Tax Values with Integer keys.
	"""
	@spec tax_values(%Building{}) :: %{String.t => %TaxValue{}}
	def tax_values(%Building{tax_values: tax_values}), do: tax_values

	@doc"""
	Convenience function for retreiving a Building's individual Tax Value
	"""
	@spec tax_value(%Building{}, String.t) :: %TaxValue{}
	def tax_value(%Building{tax_values: tax_values}, year), do: Map.get(tax_values, year)


	@doc"""
	Convenience function for adding a TaxValue to a Building
	"""
	@spec add_tax_value(%Building{}, %{}) :: %Building{}
	def add_tax_value(building, csv_row) when is_map(building) and is_map(csv_row) do
		year = Deserializer.to_year(csv_row)
		tax_value = Deserializer.to_tax_value(csv_row)
		add_tax_value(building, year, tax_value)
	end

	@spec add_tax_value(%Building{}, String.t, %TaxValue{}) :: %Building{}
	def add_tax_value(building, year, tax_value) when is_map(building) and is_map(tax_value) and is_binary(year) do
		Map.put(building, :tax_values, (Map.put(
																		Map.get(building, :tax_values), year, tax_value)))
	end

	def to_json(building) do
		Poison.Encoder.encode(building, [])
		|> List.replace_at(-1, ',\n')
	end
end