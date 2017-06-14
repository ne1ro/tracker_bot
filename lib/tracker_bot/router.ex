defmodule TrackerBot.Router do
  @moduledoc """
  Webhooks router
  """
  use Plug.Router
  alias TrackerBot.Management

  @allowed_users Application.fetch_env!(:tracker_bot, :allowed_users)

  if Mix.env == :dev, do: use Plug.Debugger

  plug :match
  plug Plug.Parsers, parsers: [:json], pass:  ["text/*", "application/*"], json_decoder: Poison
  plug :dispatch

  post "/webhooks" do
    %{"message" => %{"chat" => %{"id" => chat_id, "username" => username}, "text" => text}} = conn.body_params
    IO.inspect(text)
    authorize!(conn, username, chat_id)
  end

  match _ do
    send_resp(conn, 401, "Sorry, can't authorize you :(")
  end

  defp authorize!(conn, username, chat_id) do
    case username in @allowed_users do
      true ->
        Nadia.send_message(chat_id, "Start processing report 😫 ...")
        Nadia.send_message(chat_id, Management.report())
        send_resp(conn, 201, "")
      _ ->
        text = "STOP RIGHT HERE CRIMINAL SCUM"
        Nadia.send_message(chat_id, text)
        send_resp(conn, 401, text)
    end
  end

  defp help, do: """
    There is no help x:D

    /start - prints help
    /help - prints help
    /report [project name] - prints daily report
    /projects - prints list of the projects
  """
end
