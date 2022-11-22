defmodule BitcoinCoreClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :bitcoin_core_client,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      application: [applications: [:httpoison]],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hammox, "~> 0.7", only: :test},
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.4"},
      {:chumak, "~> 1.4"},
      {:binary, "~> 0.0.5"}
    ]
  end
end
