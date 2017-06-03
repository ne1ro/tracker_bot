defmodule Management do
  @moduledoc """
    Management related logic
  """
  @omitted_states ~w(accepted)

  def report, do: Pivotal.list_projects |> hd |> Map.get("id") |> report
  def report(project_id) do
    project_id
    |> Pivotal.list_stories
    |> Enum.reject(fn(%{"current_state" => state}) -> state in @omitted_states end)
    |> do_report
  end

  defp story_template(%{"current_state" => state} = story), do: """
    1) #{story["name"]}
    *Status*: In-Progress
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  """
  defp story_template(_), do: ""

  defp do_report(stories) when length(stories) > 0 do
    """
    Hello everybody!

    Below please find the report with the development progress:
    ________________________________________

    DAILY REPORT: #{Timex.now}
    - #{Timex.now} -
    ________________________________________

    QUESTIONS/COMMENTS:

    PERSON1:

    #{Enum.map_join(stories, &story_template/1)}

    Thanks,
    Manager
    """
  end

  defp do_report(_), do: "Nothing to report 😴"
end
