defmodule Policies.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :policies,
      version: "0.1.2",
      build_path: "_build",
      config_path: "config/config.exs",
      deps_path: "deps",
      lockfile: "mix.lock",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      package: package(),
      name: "Policies",
      description: "Policies a wrapper to work with current_user.",
      source_url: "https://github.com/paridin/policies",
      homepage_url: "https://paridin.com",
      docs: [
        # The main page in the docs
        main: "Policies",
        # logo: "logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {Policies.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.4"},
      {:policy_wonk, "~> 1.0.0"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
    ]
  end
end
