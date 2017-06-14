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

  post "/report" do
    {:ok, body, _conn} = read_body(conn)
    IO.inspect(body)
    send_resp(conn, 202, "world")
  end

  match _ do
    send_resp(conn, 401, "Sorry, can't authorize you :(")
  end
end
