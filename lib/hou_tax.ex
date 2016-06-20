defmodule HouTax do
	use Application

	def start(_type, _args) do
		IO.puts "Starting #{__MODULE__}"
		HouTax.Supervisor.start_link
	end
	
	def process(csv) when is_binary(csv) do
		csv
		|> Path.expand(__DIR__)
		|> HouTax.Reader.process
	end

	def process(csvs) when is_list(csvs) do
		for csv <- csvs, do: process(csv)
	end

	def report(building_id) do
		building_id
		|> Building.Cache.server_process
		|> Building.Server.report
	end

	def to_json(building_id) do
		Building.Server.write(building_id)
	end

	def write_all(group) do
		HouTax.Writer.write_all(group)
	end

end