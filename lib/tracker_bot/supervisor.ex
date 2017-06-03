defmodule TrackerBot.Supervisor do
  @moduledoc """
  Main app supervisor
  """

  use Supervisor
  require Logger

  def start_link,
    do: Supervisor.start_link(__MODULE__, :ok, name: TrackerBot.Supervisor)

  @spec init(:ok) ::
    {:ok, {:supervisor.sup_flags, [Supervisor.Spec.spec]}}
  def init(:ok) do
    _ = Logger.info("Start Tracker Bot supervisor")
    supervise([], strategy: :one_for_one)
  end
end
