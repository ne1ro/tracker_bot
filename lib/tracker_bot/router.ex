defmodule TrackerBot.Router do
  @moduledoc """
  Webhooks router
  """
  use Plug.Router

  @allowed_users Application.get_env(:tracker_bot, :allowed_users, [])

  if Mix.env == :dev, do: use Plug.Debugger

  plug :match
  plug Plug.Parsers, parsers: [:json], pass:  ["text/*", "application/*"], json_decoder: Poison
  plug :dispatch

  post "/webhooks" do
    IO.inspect(@allowed_users)
    %{"message" => %{"chat" => %{"id" => chat_id, "username" => username}, "text" => text}} = conn.body_params
    IO.inspect(text)
    IO.inspect(username)
    Nadia.send_message(chat_id, help())

    send_resp(conn, 202, "")
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
