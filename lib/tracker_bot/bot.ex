defmodule TrackerBot.Bot do
  alias TrackerBot.Management

  @limit 4096
  @default_project Application.fetch_env!(:tracker_bot, :default_project)

  def send_version(chat_id) do
    with {:ok, version} <- :application.get_key(:tracker_bot, :vsn) do
      Nadia.send_message(chat_id, version)
    else
      _ -> Nadia.send_message(chat_id, "N/A")
    end
  end

  def send_report(chat_id, name),
    do: name |> Management.report |> split_message(chat_id)

  def send_accepted(chat_id),
    do: split_message(Management.list_accepted(), chat_id)

  def send_message(chat_id, :projects),
    do: Nadia.send_message(chat_id, Management.list_projects())

  def send_message(chat_id, :accepted),
    do: split_message(Management.list_accepted(), chat_id)

  def send_message(chat_id, :help),
    do: Nadia.send_message(chat_id, help())

def send_message(chat_id, :default_project),
  do: Nadia.send_message(chat_id, @default_project)

  def help, do: """
  /report - create a daily report for the first project
  /report [project name] - prints daily report
  /accepted - shows list of the accepted stories
  /projects - returns list of the projects
  /default_project - shows name of the default project
  /start - prints this
  /help - prints this
  /version - shows version number
  """

  defp split_message(message, chat_id) do
    message
    |> Stream.unfold(&String.split_at(&1, @limit))
    |> Enum.take_while(&(&1 != ""))
    |> Enum.each(&(Nadia.send_message(chat_id, &1)))
  end
end
