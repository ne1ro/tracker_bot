defmodule TrackerBot.Management do
  @moduledoc """
  Management related logic
  """
  import Reporting

  alias TrackerBot.{Pivotal, Reporting}

  @omitted_states ~w()

  def report, do: Pivotal.list_projects |> hd |> Map.get("id") |> report
  def report(project_id) do
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

  defp assign_stories(%{"person" => %{"id" => id}} = user, stories) do
    user
    |> Map.get("person")
    |> Map.put(:stories, Enum.filter(stories, &(owner?(&1, id))))
  end

  defp owner?(%{"owner_ids" => owner_ids}, id), do: id in owner_ids
end
