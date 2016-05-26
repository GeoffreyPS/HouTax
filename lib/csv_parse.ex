defmodule CsvParse do
	@moduledoc"""
		Contains functions repsonsible for deserializing CSV rows and transforming them into data structures Building and TaxValue
	"""

	@doc"""
	Accepts a CSV row (with headers) and returns a TaxValue
	"""
	@spec to_tax_value(map) :: %TaxValue{}
	def to_tax_value(%{"Property_Class" => building_type, "GROSSVAL" => gross_value, "TAXVALUE" => taxed_value}) do
 		tax_value = %TaxValue{building_type: building_type, gross_value: String.to_integer(gross_value), taxed_value: String.to_integer(taxed_value)}
	end

	@doc"""
	Accepts a CSV row (with headers) and returns a Building
	"""
	@spec to_building(map) :: %Building{}
	def to_building(%{"CAN" => id, "PNUMBER" => street_number, "PSTRNAME" => street_name, "ZIPCODE" => zip}) do
		building = %Building{id: String.to_integer(id), street_number: String.to_integer(street_number), street_name: street_name,
												city: "Houston", zip: String.to_integer(zip)}
	end

	@spec building_with_value(map, integer) :: %Building{}
	def building_with_value(row, year) do
		building = to_building(row)
		%Building{building | tax_values: %{year => to_tax_value(row)} }
	end

end
