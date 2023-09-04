defmodule HoneyBucket.WebSocket do
  use WebSockex
  require Logger

  def start_link(state) do
    WebSockex.start_link("wss://eventsub.wss.twitch.tv/ws", __MODULE__, state)
  end
  
  def handle_frame({type, msg}, state) do
    IO.puts "Received WS Message - Type: #{inspect type} -- Message: #{inspect msg}"
    # pull out session ID
   {:ok, json } = Jason.decode(msg)
    if json["metadata"]["message_type"] === "session_welcome" do
      session_id = json["payload"]["session"]["id"] 
      # create subscriptions with it (POST)
      subscribe "channel.follow", session_id
    end
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end

  defp subscribe(event_type, session_id) do
    url = "https://api.twitch.tv/helix/eventsub/subscriptions"
    text = %{
      type: event_type,
      version: "2",
      condition: %{
        broadcaster_user_id: "777095801",
        moderator_user_id: "777095801"
      },
      transport: %{
        method: "websocket",
        session_id: session_id
      }

    }
    {:ok, body } = Jason.encode(text)
    headers = [
      {"Authorization", "Bearer #{System.get_env("TWITCH_OAUTH_TOKEN")}"},
      {"Client-Id", System.get_env("TWITCH_CLIENT_ID")},
      {"Content-Type", "application/json"},
    ]
    {:ok, response } = HTTPoison.post url, body, headers
    Logger.debug(inspect response)
  end
end
