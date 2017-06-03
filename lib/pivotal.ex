defmodule Pivotal do
  @moduledoc """
  Pivotal Tracker API wrapper
  """

  use HTTPoison.Base
  require Logger

  @base_url "https://www.pivotaltracker.com/services/v5/"
  @token Application.fetch_env!(:tracker_bot, :pivotal_api_token)
  @project_attributes ~w(id name)

  def list_projects do
    with {:ok, %{body: projects}} <- get("/projects"),
      do: Enum.map(projects, &(Map.take(&1, @project_attributes)))
  end

  def list_people(project_id) do
    with {:ok, %{body: people}} <- get("/my/people?project_id=#{project_id}")
    do
      people
    end
  end

  defp process_url(url), do: @base_url <> url

  defp process_response_body(body) do
    Logger.debug("Pivotal API response: #{body}")
    Poison.decode!(body)
  end

  defp process_request_headers(headers), do: headers ++ ["X-TrackerToken": @token]
end
