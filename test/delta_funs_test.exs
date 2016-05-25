defmodule DeltaFunsTest do
  use ExUnit.Case
  doctest CsvParse


  setup_all do 
    {:ok, building: %Building{
                      tax_values: %{
                        2012 => %TaxValue{gross_value: 10_000, taxed_value: 8_000, value_delta: nil, annual_delta: 0},
                        2013 => %TaxValue{gross_value: 12_000, taxed_value: 6_000, value_delta: nil, annual_delta: 0},
                        2014 => %TaxValue{gross_value: 11_000, taxed_value: 7_000, value_delta: nil, annual_delta: 0}
                      }
    }}
  end

  test "function find_annual_deltas returns a Building with Annual Deltas for each year", meta do
    
    %{2012 => %TaxValue{annual_delta: ad_2012}, 
      2013 => %TaxValue{annual_delta: ad_2013}, 
      2014 => %TaxValue{annual_delta: ad_2014}} = Map.get(TaxValue.DeltaFuns.find_annual_deltas(meta[:building]), :tax_values)

    assert(ad_2012 == 0 && ad_2013 == -2_000 && ad_2014 == 1_000)
  end

  test "function find_value_deltas returns a Building with Value Deltas for each year", meta do

    %{2012 => %TaxValue{value_delta: vd_2012}, 
      2013 => %TaxValue{value_delta: vd_2013}, 
      2014 => %TaxValue{value_delta: vd_2014}} = Map.get(TaxValue.DeltaFuns.find_value_deltas(meta[:building]), :tax_values)
      
    assert(vd_2012 == 2_000 && vd_2013 == 6_000 && vd_2014 == 4_000)
  end

  test "function find_deltas returns Building with both Value and Annual Deltas for each year", meta do
    %{2012 => %TaxValue{value_delta: vd_2012, annual_delta: ad_2012}, 
      2013 => %TaxValue{value_delta: vd_2013, annual_delta: ad_2013}, 
      2014 => %TaxValue{value_delta: vd_2014, annual_delta: ad_2014}} = Map.get(TaxValue.DeltaFuns.find_deltas(meta[:building]), :tax_values)

      assert((vd_2012 == 2_000 && vd_2013 == 6_000 && vd_2014 == 4_000) && (ad_2012 == 0 && ad_2013 == -2_000 && ad_2014 == 1_000))
  end

end