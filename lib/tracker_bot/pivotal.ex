defmodule TrackerBot.Pivotal do
  @moduledoc """
  Pivotal Tracker API wrapper
  """

  use HTTPoison.Base
  require Logger

  @limit 300
  @ttl 30 # days

  @base_url "https://www.pivotaltracker.com/services/v5/"
  @token Application.fetch_env!(:tracker_bot, :pivotal_api_token)
  @default_project Application.fetch_env!(:tracker_bot, :default_project)

  def list_projects do
    with {:ok, %{body: projects}} <- get("/projects"), do: projects
  end

  def default_project do
    Enum.find(list_projects(), fn(%{"name" => name}) -> name == @default_project end)
  end

  def list_people(project_id) do
    with {:ok, %{body: people}} <- get("/my/people?project_id=#{project_id}")
    do
      people
    end
  end

  def list_stories(project_id) do
    params = URI.encode_query(%{
      limit: @limit,
      offset: 0,
      envelope: "true",
      created_after: Timex.now |> Timex.shift(days: -@ttl) |> Timex.format!("{ISO:Extended:Z}")
    })

    with {:ok, %{body: %{"data" => stories}}} <- get("/projects/#{project_id}/stories?#{params}")
    do
      stories
    end
  end

  defp process_url(url), do: @base_url <> url

  defp process_response_body(body) do
    Logger.debug(fn -> "Pivotal API response: #{body}" end)
    Poison.decode!(body)
  end

  defp process_request_headers(headers), do: headers ++ ["X-TrackerToken": @token]
end
