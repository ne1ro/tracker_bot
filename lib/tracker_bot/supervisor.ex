defmodule TrackerBot.Supervisor do
  @moduledoc """
  Main app supervisor
  """

  use Supervisor
  require Logger
  alias Plug.Adapters.Cowboy
  alias TrackerBot.Router

  @cowboy_opts Application.fetch_env!(:tracker_bot, :cowboy_opts)

  def start_link,
    do: Supervisor.start_link(__MODULE__, :ok, name: TrackerBot.Supervisor)

  @spec init(:ok) ::
    {:ok, {:supervisor.sup_flags, [Supervisor.Spec.spec]}}
  def init(:ok) do
    _ = Logger.info("Start Tracker Bot supervisor")
    children = [Cowboy.child_spec(protocol(), Router, [], @cowboy_opts)]

    supervise(children, strategy: :one_for_one)
  end

  defp protocol do
    case System.get_env("MIX_ENV") == "prod" do
      true -> :https
      _ -> :http
    end
  end
end
