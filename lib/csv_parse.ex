defmodule CsvParse do
	@moduledoc"""
		Contains functions repsonsible for deserializing CSV rows and transforming them into data structures Building and TaxValue
	"""

	@doc"""
	Accepts a CSV row (with headers) and returns a TaxValue
	"""
	@spec to_tax_value(map) :: %TaxValue{}
	def to_tax_value(%{"Property_Class" => building_type, "GROSSVAL" => gross_value, "TAXVALUE" => taxed_value}) do
 		tax_value = %TaxValue{building_type: building_type, gross_value: gross_value, taxed_value: taxed_value}
	end

end



# %{"LEGAL2" => "(NM)", "DUEDATE" => "2/1/13 12:00 AM", "GROSSVAL" => "4200",
#    "NAMELINE2" => "PARCEL 1C (BELTWAY 8)", "CONDELFLG" => "", "LEGAL5" => "",
#    "Property_Class" => "Other Exempt (Incl Public, Religious, Charitable)",
#    "VETERAN" => "", "Roll_Type" => "Bank", "CAN" => "0150050150002",
#    "LEGACRES" => "0", "ZIPCODE" => "772511386",
#    "PSTRNAME" => "S SAM HOUSTON PKY E", "LEVY" => "0", "DATE_3307" => "",
#    "DATE_3348" => "", "OVER65" => "", "CODE_2525" => "",
#    "PR65_START" => "1/2/1990", "PZIP" => "77053", "CITY" => "HOUSTON",
#    "Roll_Code" => "R", "PNUMBER" => "0", "DATE_3308" => "",
#    "NAMELINE3" => "PO BOX 1386", "COUNTRY" => "USA",
#    "TAXDEFSTRT" => "1/0/00 0:00", "NAMELINE4" => "", "LEGAL4" => "",
#    "LEGAL3" => "FRUITLAND", "APRDISTACC" => "0150050150002",
#    "TAXDEFEND" => "1/0/00 0:00", "STATE" => "TX", "Property_Class_Code" => "XV",
#    "NAMELINE1" => "STATE DEPT HWY & PUB TRANS", "DISABLED" => "",
#    "TAXVALUE" => "0", "LEGAL1" => "TR 1A BLK 15", "HOMESTEAD" => ""}