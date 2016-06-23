defmodule HouTax.CLI do
	
	# def main(args) do
	# 	{parsed_args, _remaining_args, _invalid_args} = OptionParser.parse(args)
	# 	check_path(parsed_args)
	# end


  def main(args) do
    args |> parse_args |> do_process
  end

  def parse_args(args) do
    options = OptionParser.parse(args)

    case options do
      {[path: path], _, _} -> [path]
      {[help: true], _, _} -> :help
      {[h: true], _, _} 	-> :help
      _ -> :help
    end
  end


	def do_process([path]) do
		File.cd(path)
		case File.ls do
			{:ok, files} -> 
				run(files)
			{:error, reason} ->
				IO.puts "Encountered an error:\n
								#{reason}"
		end
	end

	def do_process(:help) do
		IO.puts """
		Welcome to HouTax.

		Usage:
		./hou_tax --path path/to/csvs

		Description:
		Given a path to a directory containing .csv files of annual Houston Tax Roll data, HouTax will deserialize the data and reserialize key information as JSON into a file labeled 'houtax_export.json'. The new information contains the difference in appraised value and taxed value for each year, as well as the difference in tax value from previous years.
		"""
	end


	def run(files) do
		csvs = files
					|> filter_csvs
					|> get_paths

		IO.puts "Processing CSVs..."
		csvs
			|> HouTax.process

		IO.puts "Writing files..."
		HouTax.write_all
	end

	def filter_csvs(files) do
		files
		|> Enum.filter(&(Regex.match?(~r/.*\.csv$/, &1)))
	end

	def get_paths(csvs) do
		{:ok, new_path} = File.cwd
		paths = for csv <- csvs, do: new_path <> "/" <> csv
		Enum.map(paths, &Path.expand(&1, __DIR__))
	end

end