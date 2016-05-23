defmodule TaxValue.DeltaFuns do
	@moduledoc"""
	Functions for calculating the annual delta and value delta for a TaxValue.
	"""
	@spec calc_annual_delta(TaxValue) :: TaxValue
	def calc_annual_delta(tax_value) do
		%{ tax_value | value_delta: calc_annual_delta(tax_value[:gross_value], tax_value[:taxed_value]) }
	end

	@spec calc_annual_delta(number, number) :: number
	defp calc_annual_delta(gross_value, taxed_value), do: gross_value - taxed_value

end