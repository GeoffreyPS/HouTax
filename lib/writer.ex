defmodule HouTax.Writer do
	use GenServer

	def start_link do
		IO.puts "Starting #{__MODULE__}"
		GenServer.start_link(__MODULE__, nil, name: :writer)
	end

	def write(building) do
		GenServer.call(:writer, {:write, building})
	end

	def init(_) do
		{:ok, file} = File.open("houtax_export.json", [:append])
		{:ok, file}
	end

	def handle_call({:write, building}, _, file) do
		case IO.write(file, building) do
			:ok ->
				{:reply, :ok, file}

			:error ->
				{:reply, {:error, "Bad Write"}, file}
		end
	end

	def handle_info(_, state), do: {:noreply, state}

end