defmodule HoneyBucket.MixProject do
  use Mix.Project

  def project do
    [
      app: :honey_bucket,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ssl, :inets],
      mod: {HoneyBucket, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tmi, git: "https://github.com/mcfiredrill/tmi.ex" },
      {:websockex, "~> 0.4.3"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 2.0"},

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
