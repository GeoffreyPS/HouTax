defmodule HouTax.CLI do
	
	def main(args) do
		{parsed_args, _remaining_args, _invalid_args} = OptionParser.parse(args)
		run(parsed_args)
	end


	def run([{:path, path} | _rest]) do
		File.cd(path)
		{:ok, files} = File.ls
		csvs = Enum.filter(files, &(Regex.match?(~r/.*\.csv$/, &1)))
		pathed_csvs = for csv <- csvs, do: "." <> path <> "/" <> csv
		Enum.map(pathed_csvs, &Path.expand(&1, __DIR__))
		|> IO.inspect
		|> HouTax.process
		IO.inspect(Building.Server.report("0010160000011"))
		IO.inspect(:pg2.get_members(:buildings))
		IO.inspect(length :pg2.get_members(:buildings))
		Process.sleep(4_000)
		IO.inspect(length :pg2.get_members(:buildings))
		HouTax.write_all
		IO.inspect(length :pg2.get_members(:buildings))
	end

end