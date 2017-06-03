defmodule Management do
  @moduledoc """
    Management related logic
  """

  def report(days_ago \\ 1) do
    report_template(days_ago, [])
  end

  defp report_template(date, stories) when length(stories) > 0, do: """
    Daily report for the date - #{Timex.now}
    =======================================
    =======================================
  """
  defp report_template(_), do: "Nothing to report 😴"

  defp story_template(%{"current_state" => state} = story)
  when state is not "accepted" do
  end

  defp story_template(_), do: ""
end
