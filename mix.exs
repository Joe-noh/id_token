defmodule IDToken.MixProject do
  use Mix.Project

  def project do
    [
      app: :id_token,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: []]
  end

  def elixirc_paths(:test), do: ["lib", "test/fixtures"]
  def elixirc_paths(_else), do: ["lib"]

  defp deps do
    [
      {:joken, "~> 2.1"},
      {:jason, "~> 1.1"},
      {:mojito, "~> 0.5"},
      {:mock, "~> 0.3", only: :test}
    ]
  end
end
