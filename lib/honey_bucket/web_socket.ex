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
    message_type = json["metadata"]["message_type"]
    case message_type do
      "session_welcome" ->
        session_id = json["payload"]["session"]["id"] 
        # create subscriptions with it (POST)
        subscribe "channel.follow", session_id
        # TODO
        # subscribe "channel.subscribe", session_id
        # subscribe "channel.subscription.gift", session_id
        # subscribe "channel.cheer", session_id
      "notification" ->
        Logger.debug "got a notification"
        subscription_type = json["metadata"]["subscription_type"]
        Logger.debug "subscription_type: #{subscription_type}"
        notify_new_follower json["payload"]["event"]
      _ ->
        Logger.debug "unknown websocket message type: #{message_type}"
    end
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end

  defp notify_new_follower payload do
    username = payload["user_login"]
    message = "#{username} followed!"
    Logger.debug message
    video = "/home/tony/dropbox/vids/lain/Copland\ OS\ recreation\ \[zMLNTgomRNk\].mp4"
    System.cmd("sh", ["-c", "mpv --vo=kitty --vo-kitty-alt-screen=no --vo-kitty-config-clear=no '#{video}' >> /tmp/honey_bucket.txt"])
    { toilet_output, _exit_code } = System.cmd("figlet", ["-f", "small", message])
    HoneyBucket.FileWriter.write toilet_output, "#660066"
    # {:ok, file } = File.open "/tmp/honey_bucket.txt", [:append]
    # IO.binwrite file, out
  end

  defp subscribe(event_type, session_id) do
    url = "https://api.twitch.tv/helix/eventsub/subscriptions"
    text = %{
      type: event_type,
      version: "2",
      condition: %{
        broadcaster_user_id: System.get_env("TWITCH_BROADCASTER_ID"),
        moderator_user_id: System.get_env("TWITCH_BROADCASTER_ID")
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
