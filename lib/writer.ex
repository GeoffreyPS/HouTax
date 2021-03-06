defmodule HouTax.Writer do
	use GenServer

	def start_link do
		GenServer.start_link(__MODULE__, nil, name: :writer)
	end

	def write(building) do
		GenServer.call(:writer, {:write, building})
	end

	def write_all(group) do
		GenServer.call(:writer, {:write_all, group}, 15_000)
	end

	def init(_) do
		{:ok, file} = File.open("houtax_export.json", [:append])
		{:ok, file}
	end

	def handle_call({:write, building}, _, file) do
		case IO.write(file, building) do
			:ok ->
				{:reply, :ok, file}
		end
	end

	def handle_call({:write_all, group}, _, file) do
		json = :pg2.get_members(group)
						|> Stream.map(&(Building.Server.to_json(&1)))

		Enum.each(json, &(IO.write(file, &1)))
		IO.puts "Finished write!"
		{:reply, :ok, file}
	end

	def handle_info(_, state), do: {:noreply, state}

end