defmodule HouTax do
	use Application

	def start(_type, _args) do
		IO.puts "Starting #{__MODULE__}"
		Building.Supervisor.start_link
	end
	
end