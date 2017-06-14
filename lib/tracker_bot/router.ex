defmodule TrackerBot.Router do
  @moduledoc """
  Webhooks router
  """
  use Plug.Router
  alias Plug.Conn

  if Mix.env == :dev, do: use Plug.Debugger

  plug :match
  plug Plug.Parsers, parsers: [:json], pass:  ["text/*", "application/*"],
                     json_decoder: Poison
  plug :dispatch

  post "/webhooks" do
    IO.inspect(conn.body_params)
    %{"message" => %{"from" => %{"id" => chat_id}}} = conn.body_params
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
