defmodule TrackerBot.Bot do
  @moduledoc """
  Slack bot for management through Pivotal Tracker
  """

  use Slack
  alias TrackerBot.Management
  require Logger

  @channel "#reports"

  def handle_connect(slack, state) do
    Logger.debug("Connected to Slack as #{slack.me.name}")
    {:ok, state}
  end

  def handle_info({:message, message}, slack, state) do
    send_message("*I got a message:* #{message}", @channel, slack)
    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  def handle_close(reason, _slack, _state) do
    Logger.debug("Disconnected from Slack because of #{reason}")
    :close
  end
end
