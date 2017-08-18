defmodule TrackerBot.Management do
  @moduledoc """
  Management related logic
  """

  alias TrackerBot.{Pivotal, Reporting, Labeling}

  @omitted_states ~w(unstarted accepted unscheduled)
  @ttl 32 # hours

  def list_projects,
    do: Enum.map_join(Pivotal.list_projects, ",", &(Map.get(&1, "name")))

  def report(project_id) when is_integer(project_id) do
    stories =
      project_id
      |> Pivotal.list_stories
      |> Enum.reject(fn(%{"current_state" => state}) -> state in @omitted_states end)
      |> filter_by_day("updated_at", "created_at")

    project_id
    |> Pivotal.list_people
    |> Enum.map(&(assign_stories(&1, stories)))
    |> Enum.group_by(fn(%{stories: stories}) -> find_label(stories) end)
  end

  def report(project_name) do
    Pivotal.list_projects
    |> Enum.find(fn(%{"name" => name}) -> name == project_name end)
    |> Map.get("id")
    |> report
  end

  def list_accepted do
    project_id = Map.get(Pivotal.default_project(), "id")

    stories =
      project_id
      |> Pivotal.list_stories
      |> Enum.filter(fn(%{"current_state" => state}) -> state == "accepted" end)
      |> filter_by_day("accepted_at")

    res =
      project_id
      |> Pivotal.list_people
      |> Enum.map(&(assign_stories(&1, stories)))
      |> Reporting.report

    File.write!("report.txt", res)
  end

  defp assign_stories(%{"person" => %{"id" => id}} = user, stories) do
    user
    |> Map.get("person")
    |> Map.put(:stories, Enum.filter(stories, &(owner?(&1, id))))
  end

  defp filter_by_day(stories, field1, field2) do
    Enum.filter(stories, fn(%{^field1 => time1, ^field2 => time2}) ->
      compare(time1) || compare(time2)
    end)
  end

  defp filter_by_day(stories, field) do
    Enum.filter(stories, fn(%{^field => time}) -> compare(time) end)
  end

  defp compare(time) do
    time
    |> Timex.parse!("{ISO:Extended:Z}")
    |> Timex.compare(Timex.shift(Timex.now, hours: -@ttl)) == 1
  end

  defp owner?(%{"owner_ids" => owner_ids}, id), do: id in owner_ids

  defp find_label(stories) when is_list(stories), do: stories |> List.first |> find_label
  defp find_label(%{"labels" => labels}), do: Labeling.get_label(labels)
  defp find_label(_), do: Labeling.get_label([])
end
