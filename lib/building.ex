defmodule Building do
	@typedoc"""
	Serves as the main data structure for a given address. tax_values holds a map of TaxValues with years as a key.
	"""
	defstruct [
		:id, :street_number, :street_name,
		:city, :zip, tax_values: %{}
	]

	@type t :: %Building{id: String.t, street_number: integer, street_name: String.t, 
											city: String.t, zip: integer, tax_values: %{integer => TaxValue}}
end