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
    %{chat_id: chat_id} = conn.assigns
    Nadia.send_message(chat_id, "Start processing report 😫 ...")
    Nadia.send_message(chat_id, Management.report())
    send_resp(conn, 201, "")
  end

  match _ do
    send_resp(conn, 401, "Sorry, can't authorize you :(")
  end

  defp help, do: """
    There is no help x:D

    /start - prints help
    /help - prints help
    /report [project name] - prints daily report
    /projects - prints list of the projects
  """
end
