defmodule Cannes.MixProject do
  use Mix.Project

  @version "0.0.3"

  def project do
    [
      app: :cannes,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/fklement/cannes",
      docs: documentation(),
      package: package(),
      description: description()
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
      {:export, "~> 0.1.1"},
      {:porcelain, "~> 2.0"},
      {:jason, "~> 1.2"},

      # DEV-DEPS
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  # Package info.
  defp package do
    [
      files: [
        "data",
        "lib",
        "mix.exs",
        ".formatter.exs",
        "README.md",
        "CHANGELOG.md",
        "requirements.txt",
        "LICENSE"
      ],
      maintainers: ["Felix Klement"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/fklement/cannes"}
    ]
  end

  # Description.
  defp description do
    """
    A library for `CAN` written in Elixir.
    """
  end

  # Documentation.
  defp documentation do
    [
      main: "Cannes",
      source_ref: "v#{@version}",
      logo: "logo.png",
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end
end
