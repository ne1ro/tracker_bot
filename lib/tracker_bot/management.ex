defmodule TrackerBot.Management do
  @moduledoc """
  Management related logic
  """
  alias TrackerBot.{Pivotal, Reporting}

  @omitted_states ~w(unstarted accepted unscheduled)

  def list_projects,
    do: Enum.map_join(Pivotal.list_projects, ",", &(Map.get(&1, "name")))

  def report, do: Pivotal.list_projects |> hd |> Map.get("id") |> report
  def report(project_id) when is_integer(project_id) do
    stories =
      project_id
      |> Pivotal.list_stories
      |> Enum.reject(fn(%{"current_state" => state}) -> state in @omitted_states end)

    report =
      project_id
      |> Pivotal.list_people
      |> Enum.map(&(assign_stories(&1, stories)))
      |> Reporting.report

    File.write("report.txt", report)
  end
  def report(project_name) do
    Pivotal.list_projects
    |> Enum.find(fn(%{"name" => name}) -> name == project_name end)
    |> Map.get("id")
    |> report
  end

  defp assign_stories(%{"person" => %{"id" => id}} = user, stories) do
    user
    |> Map.get("person")
    |> Map.put(:stories, Enum.filter(stories, &(owner?(&1, id))))
  end

  defp owner?(%{"owner_ids" => owner_ids}, id), do: id in owner_ids
end
