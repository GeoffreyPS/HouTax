defmodule DeserializerTest do
  use ExUnit.Case
  doctest HouTax

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

  test "building_with_value returns a valid building with correct tax value", meta do
    building = Deserializer.building_with_value(meta[:row])
    year = Map.get(building, :tax_values) |> Map.keys |> List.first
    assert year == 2012
  end

  test "get_id returns a 13-digit string ID when given a CSV row", meta do
    id = Deserializer.get_id(meta[:row])
    assert Regex.match?(~r/\d{13}/, "0150110000008")
  end

end