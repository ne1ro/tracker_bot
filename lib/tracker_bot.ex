defmodule TrackerBot do
  @moduledoc """
  Entry point of library/application.
  """

  require Logger

  @spec start(any(), any()) :: :ignore | {:error, any()} | {:ok, pid}
  def start(_type \\ nil, _args \\ nil) do
    _ = Logger.info("Start Tracker Bot app")
    TrackerBot.Supervisor.start_link
  end
end
