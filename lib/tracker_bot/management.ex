defmodule Management do
  @moduledoc """
    Management related logic
  """
  @omitted_states ~w(accepted)

  def report, do: Pivotal.list_projects |> List.last |> Map.get("id") |> report
  def report(project_id) do
    stories =
      project_id
      |> Pivotal.list_stories
      |> Enum.reject(fn(%{"current_state" => state}) -> state in @omitted_states end)

    report =
      project_id
      |> Pivotal.list_people
      |> Enum.map(&(assign_stories(&1, stories)))
      |> do_report

    File.write("report.txt", report)
  end

  defp owner?(%{"owner_ids" => owner_ids}, id), do: id in owner_ids

  defp assign_stories(%{"person" => %{"id" => id}} = user, stories) do
    user
    |> Map.get("person")
    |> Map.put(:stories, Enum.filter(stories, &(owner?(&1, id))))
  end

  defp user_template(%{stories: stories} = user) when length(stories) > 0, do:
  """
  #{String.upcase(user["name"])}:

  #{stories |> Enum.with_index |> Enum.map_join(&story_template/1)}
  """
  defp user_template(_), do: ""

  defp story_template({story, index}) do
    """
    #{index + 1}) #{story["name"]}
    #{story["url"]}
    *Status*: #{String.capitalize(story["current_state"])}
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    """
  end
  defp story_template(_), do: ""

  defp do_report(people) when length(people) > 0 do
    """
    Hello everybody!

    Below please find the report with the development progress:
    ________________________________________

    *DAILY REPORT: #{Timex.format!(Timex.now, "%b %eth", :strftime)}*
    *- #{Timex.format!(Timex.now, "%A", :strftime)} -*
    ________________________________________

    *QUESTIONS/COMMENTS:*

    -

    ________________________________________
    #{Enum.map_join(people, &user_template/1)}
    Thanks,
    Yuliana
    """
  end
  defp do_report(_), do: "Nothing to report 😴"
end
