defmodule HouTax.Reader do
	use GenServer
	require CSV
	require Deserializer

	def start_link do
		IO.puts "Starting #{__MODULE__}"
		GenServer.start_link(__MODULE__, nil, name: :csv_reader)
	end

	def init(_) do
		{:ok, nil}
	end

	def process(csv) do
		GenServer.cast(:csv_reader, {:process, csv})
	end

	def handle_cast({:process, csv}) do
		csv
		|> Path.expand(__DIR__)
		|> File.stream!
		|> CSV.decode(headers: true)
		|> Enum.each(&delegate_building(&1))
		{:noreply, nil}
	end

	def handle_info(_, state) do
		{:noreply, nil}
	end

	def delegate_building(row) do
		id = Deserializer.get_id(row)
		pid = Building.Cache.server_process(id)
		Building.Server.put_row(pid, row)
	end


end



# [ [h_2012 | t_2012] | [ 2013 [ 2014 [2015]]]]