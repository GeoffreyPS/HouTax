defmodule HouTax.Mixfile do
  use Mix.Project

  def project do
    [app: :hou_tax,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     escript: escript
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :gproc, :revolver],
      mod: {HouTax, []}
    ]
  end

  def escript do
    [main_module: HouTax.CLI]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:csv, "~> 1.4.0"},
      {:poison, "~> 2.0"},
      {:gproc, "~> 0.5"},
      {:dialyxir, "~> 0.3", only: [:dev]},
      {:revolver, github: "odo/revolver" }
    ]
  end
end
