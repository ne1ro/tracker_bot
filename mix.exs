defmodule TrackerBot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tracker_bot,
      version: "0.5.2",
      elixir: "~> 1.5",
      name: "Tracker Bot",
      homepage_url: "https://github.com/ne1ro/tracker_bot",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      escript: [main_module: TrackerBot.CLI],
      docs: [extras: ["README.md"], output: "./doc/app"],
      deps: deps(),
      aliases: aliases(),
      dialyzer: dialyzer()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {TrackerBot, []},
      extra_applications: ~w(logger cowboy plug)a,
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # This makes sure your factory and any other modules in test/support are compiled
  # when in the test environment.
  defp elixirc_paths(:test), do: ~w(lib test/support)
  defp elixirc_paths(_), do: ~w(lib)

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
      {:cowboy, "~> 1.0.0"},
      {:credo, "~> 0.8", only: ~w(dev test)a},
      {:dialyxir, "~> 0.4", only: ~w(dev test)a, runtime: false},
      {:distillery, "~> 1.4"},
      {:edeliver, ">= 1.2.9", only: :dev},
      {:edeliver, "~> 1.4"},
      {:effects, "~> 0.1.0"},
      {:eper, "~> 0.94.0", only: :dev},
      {:espec, "~> 1.5.1", only: :test},
      {:ex_doc, "~> 0.11", only: :dev},
      {:ex_machina, "~> 0.6.1", only: ~w(dev test)a},
      {:faker, "~> 0.5", only: :test},
      {:guardsafe, "~> 0.5.0"},
      {:hackney, "~> 1.8"},
      {:httpoison, "~> 0.13.0"},
      {:logger_file_backend, "~> 0.0.9"},
      {:monadex, "~> 1.1.3"},
      {:nadia, "~> 0.4"},
      {:observer_cli, "~> 1.3.1", only: :dev},
      {:plug, "~> 1.3"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.1"}
    ]
  end

  # Dialyzer's configuration
  def dialyzer,
    do: [
      plt_add_deps: :apps_direct,
      flags: ~w(-Wunmatched_returns -Werror_handling -Wrace_conditions -Wunderspecs
              -Wunknown -Woverspecs -Wspecdiffs)
    ]

  defp aliases do
    [
      build: "release",
      server: "run",
      quality: ["compile --warnings-as-errors --force", "credo --strict", "dialyzer"],
      setup: [
        "local.hex --force",
        "local.rebar --force",
        "deps.get",
        "compile"
      ]
    ]
  end
end
