defmodule TrackerBot.Bot do
  @moduledoc """
  Telegram bot for management through Pivotal Tracker
  """

  alias TrackerBot.Management
  require Logger

  @channel Application.fetch_env!(:tracker_bot, :allowed_channel)
end
