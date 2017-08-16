defmodule TrackerBot.Labeling do
  @moduledoc """
  Get user's label by her or his stories
  """

  @default_label "be"
  @allowed_labels ~w(be fe ios android ui)

  def get_label([]) do
    @default_label
  end

  def get_label(labels) when is_list(labels) do
    Enum.find(labels, fn(%{"name" => name}) -> name in @allowed_labels end, @default_label)
  end
end
