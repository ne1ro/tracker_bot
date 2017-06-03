defmodule Pivotal do
  @moduledoc """
  Pivotal Tracker API wrapper
  """

  use HTTPoison.Base
  require Logger

  @base_url "https://www.pivotaltracker.com/services/v5/"
  @token Application.fetch_env!(:tracker_bot, :pivotal_api_token)

  def process_url(url), do: @base_url <> url

  def process_response_body(body) do
    Logger.debug("Pivotal API response: #{body}")
    Poison.decode(body)
  end

  defp process_request_headers(headers), do: headers ++ ["X-TrackerToken": @token]
end
