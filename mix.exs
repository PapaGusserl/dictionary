defmodule Dictionary.Mixfile do
  use Mix.Project

  def project do
    [
      app: :dictionary,
      version: "0.0.1",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  defp escript do
    [
      main_module: Dict.CLI,
      name: :dict
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :httpoison ],
               mod: {Dictionary, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.9.0"},
	  {:json,      "~> 0.3.0"},
      {:mailgun,   "~> 0.1.2"}
    ]
  end
end
