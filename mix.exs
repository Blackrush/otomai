defmodule Otomai.Mixfile do
  use Mix.Project

  def project do
    [
      app:     :otomai,
      version: "0.0.1",
      elixir:  "~> 1.0",
      deps:    deps(Mix.env),
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {Otomai, []},
      applications: applications(Mix.env),
    ]
  end

  defp applications(:dev) do
    applications(:prod) ++ ~w(reprise)a
  end

  defp applications(:prod) do
    ~w(logger ranch)a
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps(:dev) do
    deps(:prod) ++ [
      reprise: "~> 0.3.0",
    ]
  end

  defp deps(:prod) do
    [
      ranch: "~> 1.0.0",
    ]
  end
end
