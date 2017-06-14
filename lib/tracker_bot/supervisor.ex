defmodule TrackerBot.Supervisor do
  @moduledoc """
  Main app supervisor
  """

  use Supervisor
  require Logger
  alias Plug.Adapters.Cowboy
  alias TrackerBot.Router

  def start_link,
    do: Supervisor.start_link(__MODULE__, :ok, name: TrackerBot.Supervisor)

  @spec init(:ok) ::
    {:ok, {:supervisor.sup_flags, [Supervisor.Spec.spec]}}
  def init(:ok) do
    _ = Logger.info("Start Tracker Bot supervisor")
    children = [Cowboy.child_spec(:http, Router, [], port: 3000)]

    supervise(children, strategy: :one_for_one)
  end
end
