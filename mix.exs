defmodule SlackTemplate.Mixfile do
  use Mix.Project

  def project do
    [app: :slack_template,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :cowboy, :plug, :ecto, :postgrex],
      mod: {SlackTemplate, []},
      env: [cowboy_port: 8080]
    ]

  end

  # Compile support files for test environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.1"},
      {:ecto, "~> 2.0.0-rc.3"},
      {:postgrex, "~> 0.11.1"}
    ]
  end
end
