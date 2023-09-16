defmodule HoneyBucket.Tmi do
  use TMI

  @impl TMI.Handler
  def handle_message(message, sender, channel, tags) do
    Logger.debug tags
    Logger.debug sender
    tags_map = Map.new(tags)
    tags_color = Map.get(tags_map, "color")
    color = case tags_color do
      "" -> "#00ff00"
      _ -> tags_color
    end
    Logger.debug color
    Logger.debug("running toilet")
    { toilet_output, _exit_code } = System.cmd("figlet", ["-f", "chunky", "#{sender}: #{message}"])
    HoneyBucket.FileWriter.write toilet_output, color
    Logger.debug("Message in #{channel} from #{sender}: #{message}")
  end

  # defp user_color(username) do
  #   url = "https://api.twitch.tv/helix/chat/color?user_id=#{user_id(username)}"
  #   headers = [
  #     {"Authorization", "Bearer #{System.get_env("TWITCH_OAUTH_TOKEN")}"},
  #     {"Client-Id", System.get_env("TWITCH_CLIENT_ID")},
  #     {"Content-Type", "application/json"},
  #   ]
  #   {:ok, response } = HTTPoison.get url, headers
  #   Logger.debug(inspect response)
  # end
  #
  # defp user_id(username) do
  #   url = "https://api.twitch.tv/helix/users?login=#{username}"
  #   headers = [
  #     {"Authorization", "Bearer #{System.get_env("TWITCH_OAUTH_TOKEN")}"},
  #     {"Client-Id", System.get_env("TWITCH_CLIENT_ID")},
  #     {"Content-Type", "application/json"},
  #   ]
  #   {:ok, response } = HTTPoison.get url, headers
  #   body = Jason.decode!(response.body)    
  #   data = body["data"]    
  #   first_result = Enum.at(data, 0)    
  #   first_result["id"]
  # end
end
