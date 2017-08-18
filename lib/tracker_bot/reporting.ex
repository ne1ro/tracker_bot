defmodule TrackerBot.Reporting do
  @moduledoc """
  Report templates
  """

  def report(grouped_stories) when length(grouped_stories) > 0 do
    """
    Hello everybody!

    Below please find the report with the development progress:
    ________________________________________

    DAILY REPORT: #{Timex.format!(Timex.now, "%b %eth", :strftime)}
    - #{Timex.format!(Timex.now, "%A", :strftime)} -
    ________________________________________

    QUESTIONS/COMMENTS:

    -

    ________________________________________

    #{Enum.map_join(grouped_stories, &user_template/1)}
    Thanks,
    Yuliana
    """
  end
  def do_report(_), do: "Nothing to report 😴"

  defp user_template({_, []}),
    do: ""

  defp user_template({label, users}), do:
  """
  #{label}

  #{Enum.map_join(users, &user_template/1)}
  """

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
    Status: #{state(story["current_state"])}
    - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    """
  end
  defp story_template(_), do: ""

  defp state("started"), do: "WIP"
  defp state(str), do: String.capitalize(str)
end
