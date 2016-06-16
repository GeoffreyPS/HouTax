defmodule HouTax do
	use Application

	def start(_type, _args) do
		IO.puts "Starting #{__MODULE__}"
		HouTax.Supervisor.start_link
	end
	
end