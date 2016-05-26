defmodule CsvParseTest do
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

  test "to_tax_value returns a valid TaxValue", meta do
  	tax_value = CsvParse.to_tax_value(meta[:row])
    refute Map.get(tax_value, :gross_value) == nil
  end
end
