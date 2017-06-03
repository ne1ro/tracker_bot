defmodule TrackerBot do
  require Logger

  @moduledoc """
    Entry point of library/application.
  """

  @spec start(any(), any()) :: :ignore | {:error, any()} | {:ok, pid}
  def start(_type \\ nil, _args \\ nil) do
    _ = Logger.info("Start Elixir Base app")
    TrackerBot.Supervisor.start_link
  end
end
