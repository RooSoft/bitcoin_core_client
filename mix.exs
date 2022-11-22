defmodule BitcoinCoreClient.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :bitcoin_core_client,
      version: @version,
      description: "Allows access to Bitcoin Core nodes in native Elixir format",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      application: [applications: [:httpoison]],
      deps: deps(),

      # Docs
      name: "BitcoinCoreClient",
      source_url: "https://github.com/RooSoft/bitcoin_core_client",
      homepage_url: "https://github.com/RooSoft/bitcoin_core_client",
      docs: docs(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: "BitcoinCoreClient",
      extras: docs_extras(),
      assets: "/guides/assets",
      source_ref: @version,
      source_url: "https://github.com/RooSoft/bitcoin_core_client"
    ]
  end

  def docs_extras do
    [
      "README.md"
    ]
  end

  def package do
    [
      maintainers: ["Marc Lacoursière"],
      licenses: ["UNLICENCE"],
      links: %{"GitHub" => "https://github.com/RooSoft/bitcoin_core_client"}
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
