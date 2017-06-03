defmodule Pivotal do
  @moduledoc """
  Pivotal Tracker API wrapper
  """

  use HTTPoison.Base
  require Logger

  @limit 1000
  @allowed_states "accepted,delivered,finished,started,rejected,planned,unstarted,unscheduled"

  @base_url "https://www.pivotaltracker.com/services/v5/"
  @token Application.fetch_env!(:tracker_bot, :pivotal_api_token)

  def list_projects do
    with {:ok, %{body: projects}} <- get("/projects"), do: projects
  end

  def list_people(project_id) do
    with {:ok, %{body: people}} <- get("/my/people?project_id=#{project_id}")
    do
      people
    end
  end

  def list_stories(project_id) do
    params = URI.encode_query(%{limit: @limit})

    with {:ok, %{body: stories}} <- get("/projects/#{project_id}/stories?#{params}")
    do
      stories
    end
  end

  defp process_url(url), do: @base_url <> url

  defp process_response_body(body) do
    Logger.debug("Pivotal API response: #{body}")
    Poison.decode!(body)
  end

  defp process_request_headers(headers), do: headers ++ ["X-TrackerToken": @token]
end
