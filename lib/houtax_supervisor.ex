defmodule HouTax.Supervisor do
	use Supervisor

	def start_link do
		IO.puts "Starting #{__MODULE__}"
		Supervisor.start_link(__MODULE__, nil, name: :houtax_supervisor)
	end

	def init(_) do
		processes = [ 
			supervisor(Buildings.Supervisor, []),
			worker(HouTax.Reader, [])
		]
		supervise(processes, strategy: :one_for_one)
	end
	
end