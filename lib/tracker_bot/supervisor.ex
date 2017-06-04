defmodule TrackerBot.Supervisor do
  @moduledoc """
  Main app supervisor
  """

  use Supervisor
  require Logger
  alias TrackerBot.Bot

  @slack_token Application.fetch_env!(:slack, :api_token)

  def start_link,
    do: Supervisor.start_link(__MODULE__, :ok, name: TrackerBot.Supervisor)

  @spec init(:ok) ::
    {:ok, {:supervisor.sup_flags, [Supervisor.Spec.spec]}}
  def init(:ok) do
    _ = Logger.info("Start Tracker Bot supervisor")

    children = [worker(Slack.Bot,
                       [Bot, [], @slack_token, %{name: Bot}],
                       restart: :permanent)]

    supervise(children, strategy: :one_for_one)
  end
end
