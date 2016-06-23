defmodule HouTax.CLI do
	
	def main(args) do
		{parsed_args, _remaining_args, _invalid_args} = OptionParser.parse(args)
		run(parsed_args)
	end

	def run([{:path, path} | _rest]) do
		File.cd(path)
		{:ok, files} = File.ls

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

	# def await(group, files) do
	# 		unless minimum_processes_reached?(group, files)
	# 			do Process.sleep(100)
	# 				await(group, files)
	# 		else 
	# 			Process.sleep(500)
	# 	end
	# end


	# def await(group, files) do
	# 	cond do
	#   	still_growing?(group) ->
	# 			await(group, files)

	# 	  minimum_processes_reached?(group, files) -> 
	# 	  	Process.sleep(div(at_least(files), 10))

	# 		true ->
	# 			await(group, files)		    
	# 	end
	# end

	# def still_growing?(group) do
	# 	gs1 = group_size(group)
	# 	Process.sleep(50)
	# 	gs2 = group_size(group)

	# 	gs1 < gs2
	# end

	# def minimum_processes_reached?(group, files) do
	# 	group_size(group) >= at_least(files)
	# end


	# defp group_size(group) do
	# 	:pg2.get_members(group)
	# 	|> length
	# end

	# defp at_least(files) do
	# 	[filename: filename, size: _size] = largest_file files
		
	# 	filename 
	# 	|> File.stream! 
	# 	|> Enum.to_list 
	# 	|> length
	# end

	# defp largest_file(files) do
	# 	Enum.max_by(files, &size(&1))
	# 	|> file_name_size
	# end

	# defp size(file) do
	# 	{:ok, stat} = File.stat(file)	
	# 	%{size: size} = stat	
	# 	size
	# end

	# defp file_name_size(file) do
	# 	{:ok, stat} = File.stat(file)	
	# 	%{size: size} = stat	
	# 	[filename: file, size: size]
	# end

end