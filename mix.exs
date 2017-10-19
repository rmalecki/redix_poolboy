defmodule RedixPoolboy.Mixfile do
  use Mix.Project

  def project do
    [app: :redis_poolex,
     version: "0.0.1",
     elixir: "~> 1.5",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger],
      mod: {RedixPoolboy, []}
    ]
  end

  defp description do
    """
    Redis connection pool using poolboy and redix libraries. Thankfully derived from redis_poolex.
    """
  end

  defp package do
    [# These are the default files included in the package
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Niklas Bichinger"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/bichinger/redix_poolboy",
        "Docs" => "http://hexdocs.pm/redix_poolboy/"
      }
    ]
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
    [
      {:poolboy, "~> 1.5"},
      {:redix, "~> 0.6.1"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
