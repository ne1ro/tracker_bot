defmodule TrackerBot.Labeling do
  @moduledoc """
  Get user's label by her or his stories
  """

  @default_label "be"
  @allowed_labels ~w(be fe ios android ui)

  def get_label(%{stories: stories}) do
    stories
    |> Enum.flat_map(fn %{"labels" => labels} -> labels end)
    |> Enum.reduce(%{}, fn %{"name" => name}, acc ->
         case name in @allowed_labels do
           true -> Map.update(acc, name, 1, &(&1 + 1))
           _ -> acc
         end
       end)
    |> Map.to_list()
    |> Enum.max_by(fn {_, count} -> count end, fn -> {@default_label, 0} end)
    |> get_label
  end

  def get_label({label, _count}) do
    get_label(label)
  end

  def get_label(label) do
    String.upcase(label)
  end
end
