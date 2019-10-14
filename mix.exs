defmodule IDToken.MixProject do
  use Mix.Project

  def project do
    [
      app: :id_token,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:joken, "~> 2.1"},
      {:jason, "~> 1.1"},
      {:mojito, "~> 0.5.0"}
    ]
  end
end
