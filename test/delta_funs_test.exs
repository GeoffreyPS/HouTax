defmodule DeltaFunsTest do
  use ExUnit.Case
  doctest CsvParse

  test "Function calc_value_delta returns a taxed value's gross_value minus its taxed_value" do
  	 tax_vals = %{	2012 => %TaxValue{building_type: "residential", gross_value: 10_000, taxed_value: 8_000, value_delta: nil, annual_delta: 0},
  									2013 => %TaxValue{building_type: "residential", gross_value: 12_000, taxed_value: 6_000, value_delta: nil, annual_delta: 0},
  									2014 => %TaxValue{building_type: "residential", gross_value: 11_000, taxed_value: 7_000, value_delta: nil, annual_delta: 0}
  							}


  	year = Map.keys(tax_vals) |> Enum.shuffle |> List.first
  	new_val = TaxValue.DeltaFuns.calc_value_delta(Map.get(tax_vals, year))
  	assert (Map.get(new_val, :value_delta)) == (Map.get(tax_vals[year], :gross_value) - Map.get(tax_vals[year], :taxed_value))
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end