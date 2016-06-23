# HouTax
OTP and ETL demo with a command line interface using Elixir. Original open dataset from [City of Houston's Tax Rolls by Year](http://data.ohouston.org/dataset/city-of-houston-property-tax-rolls-by-year).

## To Build
	1. [Install Erlang and Elixir](http://elixir-lang.org/install.html)
	2. Clone this repository into a working directory `git clone git@github.com:GeoffreyPS/HouTax.git`.
	3. CD into the cloned repository and fetch dependencies with `mix deps.get` if you don't already have the [Hex package installer](https://hex.pm/), you will be prompted to install it as well.
	4. Build the application with `mix escript.build`

## To Run
	If you already have any instance of Erlang installed on your machine, you can run the CLI without futzing around with installing Elixir or the project's dependencies.
	1. Enter `./hou_tax` for help or `./hou_tax --path path/to/csvs` to get the application started.
	2. Sample data located in the test/data directory
	3. Export file titled `houtax_export.json` should appear.

## To Look Under the Hood
	You must have done steps 1-3 of To Build to do this part.
	1. Cd into the cloned repository and run `iex -S mix`. This starts the application in iex, Elixir's REPL.
	2. Enter `:observer.start` to see the process tree started by the application in a GUI.

```
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Starting Elixir.HouTax
Starting Elixir.Building.Cache
Starting Elixir.Buildings.Supervisor
Starting Elixir.HouTax.Writer
Interactive Elixir (1.3.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> :observer.start
:ok
iex(2)> File.cd "./test/data/20k"
:ok
iex(3)> {:ok, files} = File.ls
{:ok, ["2012_20k.csv", "2013_20k.csv", "2014_20k.csv", "2015_20k.csv"]}
iex(4)> csvs = Enum.map(files, &(Path.expand(&1, __DIR__)))
["/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/20k/2012_20k.csv",
 "/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/20k/2013_20k.csv",
 "/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/20k/2014_20k.csv",
 "/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/20k/2015_20k.csv"]
iex(5)> HouTax.process csvs
[:ok, :ok, :ok, :ok]
iex(6)> HouTax.write_all
Finished write!
:ok
iex(7)>
```

## Useful to note:
	- Each building's data exists its own distinct process. In the event of a crash or a misread, the other processes are unaffected.
	- For the full datasets, tweaks might need to be made to the BEAM/VM to allow 750,000+ processes for it all to run, plus timeout defaults might need to be changed. However, for the sample dataset of 20k+ properties, this technique works fine. Alternatively one could solve this problem with a pool of workers and caching the property information in an ETS table.
	- [Saša Jurić](https://github.com/sasa1977)'s book [Elixir in Action] provided the model for much of this exercise, with a few departures. [Benjamin Tan Wei Hao](https://github.com/benjamintanweihao)'s forthcoming book [The Little Elixir and OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook) was also very helpful.