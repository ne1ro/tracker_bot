defmodule TrackerBot.Router do
  @moduledoc """
  Webhooks router
  """
  use Plug.Router

  if Mix.env == :dev, do: use Plug.Debugger

  plug :match
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["application/json"],
                     json_decoder: Poison
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
