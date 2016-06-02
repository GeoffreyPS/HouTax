defmodule DeserializerTest do
  use ExUnit.Case
  doctest CsvParse

  setup_all do
  	csv = "./data/2012.csv"
  	row = csv
  				|> Path.expand(__DIR__)
  				|> File.stream!
  				|> CSV.decode(headers: true)
  				|> Enum.take_random(1)
  				|> List.first
  	{:ok, row: row}
  end

  test "to_tax_value returns a TaxValue with non-nil value fields", meta do
  	tax_value = Deserializer.to_tax_value(meta[:row])
    refute Map.get(tax_value, :gross_value) == nil
  end


  test "to_tax_value returns tax value fields as integers", meta do
  	tax_value = Deserializer.to_tax_value(meta[:row])
		for elem <- [:gross_value, :taxed_value], do: (Map.get(tax_value, elem) |> is_integer |> assert)
  end

  test "to_building returns a valid Building", meta do
  	building = Deserializer.to_building(meta[:row])
  	refute Map.get(building, :street_name) == nil
  end

  test "to_year returns a valid date", meta do
    date = Deserializer.to_year(meta[:row])
    assert date == 2012
  end

end
