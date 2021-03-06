# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :tracker_bot, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:tracker_bot, :key)
#
# Or configure a 3rd-party app:
#
config :tracker_bot,
  cowboy_opts: [port: System.get_env("PORT") || 3000],
  pivotal_api_token: System.get_env("PIVOTAL_API_TOKEN"),
  default_project: System.get_env("DEFAULT_PROJECT"),
  allowed_users: (System.get_env("ALLOWED_USERS") || "") |> String.split(",")

config :nadia, token: System.get_env("TELEGRAM_API_TOKEN")

config :logger, backends: [:console, {LoggerFileBackend, :file_log}]

config :logger, :console,
  level: :info,
  format: "$date $time [$node][$metadata][$level] $message\n",
  metadata: [:pid],
  colors: [info: :green]

config :logger, :file_log,
  path: "./log/tracker_bot.log",
  format: "$date $time [$node][$metadata][$level] $message\n",
  level: :debug,
  metadata: [:pid]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
if Mix.env() == :prod, do: import_config("prod.exs")
