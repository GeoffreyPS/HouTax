defmodule DeltaFunsTest do
  use ExUnit.Case
  doctest CsvParse

  test "function calc_value_delta returns a taxed value's gross_value minus its taxed_value" do
  	 tax_vals = %{	2012 => %TaxValue{gross_value: 10_000, taxed_value: 8_000, value_delta: nil, annual_delta: 0},
  									2013 => %TaxValue{gross_value: 12_000, taxed_value: 6_000, value_delta: nil, annual_delta: 0},
  									2014 => %TaxValue{gross_value: 11_000, taxed_value: 7_000, value_delta: nil, annual_delta: 0}
  							}


  	year = Map.keys(tax_vals) |> Enum.shuffle |> List.first
  	new_val = TaxValue.DeltaFuns.calc_value_delta(Map.get(tax_vals, year))
  	assert (Map.get(new_val, :value_delta)) == (Map.get(tax_vals[year], :gross_value) - Map.get(tax_vals[year], :taxed_value))
  end



  test "function find_annual_deltas returns a Building with Annual Deltas" do
    building = %Building{ 
      tax_values: %{
        2012 => %TaxValue{taxed_value: 8_000, annual_delta: 0},
        2013 => %TaxValue{taxed_value: 6_000, annual_delta: 0},
        2014 => %TaxValue{taxed_value: 7_000, annual_delta: 0}
      }
    }
    
    %{2012 => %TaxValue{annual_delta: ad_2012}, 
      2013 => %TaxValue{annual_delta: ad_2013}, 
      2014 => %TaxValue{annual_delta: ad_2014}} = Map.get(TaxValue.DeltaFuns.find_annual_deltas(building), :tax_values)

    assert(ad_2012 == 0 && ad_2013 == 6_000 && ad_2014 == 1_000)
  end

  test "the truth" do
    assert 1 + 1 == 2
  end
end