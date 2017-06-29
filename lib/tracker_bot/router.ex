defmodule TrackerBot.Router do
  @moduledoc """
  Webhooks router
  """
  use Plug.Router
  alias TrackerBot.{Plugs.Authorization, Management}

  if Mix.env == :dev, do: use Plug.Debugger

  plug :match
  plug Plug.Parsers, parsers: [:json], pass:  ["text/*", "application/*"], json_decoder: Poison
  plug Authorization
  plug :dispatch

  post "/webhooks" do
    %{chat_id: chat_id, text: text} = conn.assigns

    case text do
      "/report" -> send_report(chat_id)
      "/report " <> name -> send_report(chat_id, name)
      "/projects" -> Nadia.send_message(chat_id, Management.list_projects())
      _ -> Nadia.send_message(chat_id, help())
    end

    send_resp(conn, 201, "")
  end

  match _ do
    send_resp(conn, 401, "Sorry, can't authorize you :(")
  end

  defp send_report(chat_id) do
    send_report(chat_id, Management.list_projects |> String.split(",") |> hd)
  end

  defp send_report(chat_id, name) do
    Nadia.send_message(chat_id, "Start processing report for #{name} 😫 ...")

    name
    |> Management.report
    |> Stream.unfold(&String.split_at(&1, 4096))
    |> Enum.take_while(&(&1 != ""))
    |> Enum.each(&(Nadia.send_message(chat_id, &1)))
  end

  defp help, do: """
    There is no help x:D

    /start - prints help
    /help - prints help
    /report - prints daily report for the first project
    /report [project name] - prints daily report
    /projects - prints list of the projects
  """
end
