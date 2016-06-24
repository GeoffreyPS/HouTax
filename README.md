# HouTax
OTP and ETL demo with a command line interface using Elixir. Original open dataset from [City of Houston's Tax Rolls by Year](http://data.ohouston.org/dataset/city-of-houston-property-tax-rolls-by-year).

## But What Does It _Do_?
This application reads property/building tax data from the City of Houston's Tax Rolls by Year as csvs. For each building and each year that record of that property exists, the application will calculate how much the building's value increased or decreased. This data is then serialized as JSON and written to disk in a single export file.

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
![application tree](https://raw.githubusercontent.com/GeoffreyPS/HouTax/master/observer.png)

```elixir
$ iex -S mix
Erlang/OTP 18 [erts-7.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.3.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> :observer.start
:ok
iex(2)> File.cd "./test/data/100"
:ok
iex(3)> {:ok, files} = File.ls
{:ok, ["2012.csv", "2013.csv", "2014.csv", "2015.csv"]}
iex(4)> csvs = Enum.map(files, &(Path.expand(&1, __DIR__)))
["/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/100/2012.csv",
 "/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/100/2013.csv",
 "/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/100/2014.csv",
 "/Users/geoff/Projects/sandbox/elixir-learning/HouTax/test/data/100/2015.csv"]
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


- [Saša Jurić](https://github.com/sasa1977)'s book [Elixir in Action](https://www.manning.com/books/elixir-in-action) provided the model for much of this exercise, with a few departures. [Benjamin Tan Wei Hao](https://github.com/benjamintanweihao)'s forthcoming book [The Little Elixir and OTP Guidebook](https://www.manning.com/books/the-little-elixir-and-otp-guidebook) was also very helpful.