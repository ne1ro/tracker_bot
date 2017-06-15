defmodule TrackerBot.Plugs.Authorization do
  import Plug.Conn

  @allowed_users Application.fetch_env!(:tracker_bot, :allowed_users)
  @msg "STOP RIGHT HERE CRIMINAL SCUM"

  def init(opts), do: opts

  def call(%{body_params: %{"message" => message}} = conn, _opts) do
    %{"chat" => %{"id" => chat_id, "username" => username}, "text" => text} = message

    case username in @allowed_users do
      true ->
        conn |> assign(:chat_id, chat_id) |> assign(:text, text)
      _ ->
        Nadia.send_message(chat_id, @msg)
        send_resp(conn, 401, @msg)
    end
  end
  def call(conn, _), do: conn
end
