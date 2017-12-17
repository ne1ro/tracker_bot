defmodule TrackerBot.Router do
  @moduledoc """
  Webhooks router
  """

  use Plug.Router
  alias TrackerBot.Plugs.Authorization
  alias TrackerBot.Bot

  if Mix.env() == :dev, do: use(Plug.Debugger)

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["text/*", "application/*"], json_decoder: Poison)
  plug(Authorization)
  plug(:dispatch)

  post "/webhooks" do
    %{chat_id: chat_id, text: text} = conn.assigns

    case text do
      "/report" ->
        Bot.send_report(chat_id, Application.fetch_env!(:tracker_bot, :default_project))

      "/report " <> name ->
        Bot.send_report(chat_id, name)

      "/projects" ->
        Bot.send_message(chat_id, :projects)

      "/accepted" ->
        Bot.send_message(chat_id, :accepted)

      "/version" ->
        Bot.send_version(chat_id)

      "/default_project" ->
        Bot.send_message(chat_id, :default_project)

      "/" ->
        Bot.send_version(chat_id)

      _ ->
        Bot.send_message(chat_id, :help)
    end

    send_resp(conn, 201, "")
  end

  match _ do
    send_resp(conn, 401, "Sorry, can't authorize you :(")
  end
end
