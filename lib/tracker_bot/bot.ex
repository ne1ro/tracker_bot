defmodule TrackerBot.Bot do
  alias TrackerBot.Management

  @limit 4096

  def send_report(chat_id),
    do: send_report(chat_id, Management.list_projects |> String.split(",") |> hd)

  def send_report(chat_id, name),
    do: name |> Management.report |> split_message(chat_id)

  def send_accepted(chat_id),
    do: split_message(Management.list_accepted(), chat_id)

  def send_message(chat_id, :projects),
    do: Nadia.send_message(chat_id, Management.list_projects())

  def send_message(chat_id, :accepted),
    do: Nadia.send_message(chat_id, Management.list_accepted())

  def send_message(chat_id, :help),
    do: Nadia.send_message(chat_id, help())

  def help, do: """
  /report - prints daily report for the first project
  /report [project name] - prints daily report
  /accepted - prints list of the accepted stories
  /projects - prints list of the projects
  /start - prints help
  /help - prints help
  """

  defp split_message(message, chat_id) do
    message
    |> Stream.unfold(&String.split_at(&1, @limit))
    |> Enum.take_while(&(&1 != ""))
    |> Enum.each(&(Nadia.send_message(chat_id, &1)))
  end
end
