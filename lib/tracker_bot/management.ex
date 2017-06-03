defmodule Management do
  @moduledoc """
    Management related logic
  """

  @omitted_state "accepted"

  def report, do: Pivotal.list_projects |> hd |> Map.get("id") |> report
  def report(project_id), do: project_id |> Pivotal.list_stories |> do_report

  defp do_report(stories) when length(stories) > 0, do: """
    Daily report for #{Timex.now}
    =======================================
    #{Enum.map_join(stories, &story_template/1)}
    =======================================
    Sincerely, manager
  """
  defp do_report(_), do: "Nothing to report 😴"

  defp story_template(%{"current_state" => state} = story), do: """
    -------------------------------------------------------
    #{story["name"]}
    -------------------------------------------------------
  """

  defp story_template(_), do: ""
end
