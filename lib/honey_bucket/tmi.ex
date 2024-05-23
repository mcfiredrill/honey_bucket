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
    { toilet_output, _exit_code } = System.cmd("figlet", ["-f", "fbr2____", "#{sender}: #{message}"])
    HoneyBucket.FileWriter.write toilet_output, color
    Logger.debug("Message in #{channel} from #{sender}: #{message}")
    {:ok , msg } = handle_command(message)
    Logger.debug msg
    say(msg, channel)
  end

  def handle_command(command) do
    Logger.debug "the command: #{command}"
    case command do
      "!sorry" ->
        video = "./vids/sorry.mp4"
        play_video(video)

        msg =
          "Must have been the onion salad dressing. Right, Brendon? :sorrymusthavebeentheonionsaladdressing:"

        {:ok, msg}

      _ when command in ["!thisisamazing", "!amazing"] ->
        # shell to play
        System.cmd("play", ["./sfx/thisisamazing.mp3"])
        msg = "It's just a website"
        {:ok, msg}

      _ when command in ["!gohackyourself", "!hack"] ->
        # shell to play
        System.cmd("play", ["./sfx/go_hack_yourself.wav"])
        msg = "go hack yourself"
        {:ok, msg}

      "!pewpew" ->
        # shell to play
        System.cmd("play", ["./sfx/PEWPEW.wav"])
        msg = "pewpew"
        {:ok, msg}

      "!bass" ->
        # shell to play
        System.cmd("play", ["./sfx/bass.mp3"])
        msg = "BASS"
        {:ok, msg}

      "!scream" ->
        # shell to play
        System.cmd("play", ["./sfx/somebody_scream.wav"])
        msg = "c'mon ethel let's get outta here"
        {:ok, msg}

      "!internet" ->
        # shell to play
        System.cmd("play", ["./sfx/internet.wav"])
        msg = "https://www.youtube.com/watch?v=ip34OUo3IS0"
        {:ok, msg}

      "!penith" ->
        # shell to play
        System.cmd("play", ["./sfx/penith.wav"])
        msg = ":dizzy:"
        {:ok, msg}

      "!ballin" ->
        # shell to play
        System.cmd("play", ["./sfx/ballin.wav"])
        msg = ":lain_dad:"
        {:ok, msg}

      _ when command in ["!duck", "!ducks"] ->
        # shell to play
        video = "./vids/duck_rotation.mp4"
        play_video(video)
        msg = ":duckle:"
        {:ok, msg}

      _ when command in ["!fries", "!greasyfries"] ->
        # shell to play
        System.cmd("play", ["./sfx/greasy_fries.wav"])
        msg = ":greasyhotdogs:"
        {:ok, msg}

      _ when command in ["!hotdogs", "!greasyhotdogs"] ->
        # shell to play
        System.cmd("play", ["./sfx/greasy_hotd.wav"])
        msg = ":greasyhotdogs:"
        {:ok, msg}

      "!bug" ->
        # shell to play
        System.cmd("play", ["./sfx/bug.mp3"])
        msg = "FIX THAT BUG"
        {:ok, msg}

      "!gj" ->
        # shell to play
        video = "./vids/gj.mp4"
        play_video(video)
        msg = ":goodbeverage:"
        {:ok, msg}

      "!false" ->
        # shell to play
        System.cmd("play", ["./sfx/false.mp3"])
        msg = "it never happened"
        {:ok, msg}

      _ when command in ["!totalfabrication", "!fabrication"] ->
        # shell to play
        System.cmd("play", ["./sfx/total_fabrication.mp3"])
        msg = "it's a total fabrication"
        {:ok, msg}

      "!boost" ->
        # shell to play
        System.cmd("play", ["./sfx/boostyrdesktoplifestyle.mp3"])
        msg = ":marty:"
        {:ok, msg}

      "!computers" ->
        # shell to play
        System.cmd("play", ["./sfx/computers.mp3"])
        msg = "I hope we all learned about computers"
        {:ok, msg}

      "!done" ->
        # shell to play
        System.cmd("play", ["./sfx/done.mp3"])
        msg = "and yr done"
        {:ok, msg}

      _ when command in ["!onionrings", "!greasyonionrings"] ->
        # shell to play
        System.cmd("play", ["./sfx/greasy_onion_rings.wav"])
        msg = ":greasyhotdogs:"
        {:ok, msg}

      "!awake" ->
        # shell to play
        System.cmd("play", ["./sfx/alive_alert_awake.mp3"])
        msg = ":alive_alert_awake:"
        {:ok, msg}

      "!mustard" ->
        video = "/home/tony/dropbox/video\ projects/rendered/mustard_fixed.mp4"
        play_video(video)
        msg = "all i have to do is find the mustard and i'm in good shape"
        {:ok, msg}

      "!developers" ->
        video = "./vids/developers.mp4"
        play_video(video)
        msg = "DEVELOPERS"
        {:ok, msg}

      _ when command in ["!crunch", "!eat", "!chomp"] ->
        # shell to play
        System.cmd("play", ["./sfx/crunch.mp3"])
        msg = "yummers"
        {:ok, msg}

      "!cheese" ->
        System.cmd("play", ["./sfx/cheese.mp3"])
        msg = "now that's my kind of cheese"
        {:ok, msg}

      "!discord" ->
        msg = "join da burgerzone discord -> https://discord.gg/bkNFZjgPBN"
        {:ok, msg}

      "!sfx" ->
        # can we pull the list of sfx automatically somehow?
        list = """
        !sorry
        !thisisamazing
        !gohackyourself
        !pewpew
        !bass
        !scream
        !internet
        !penith
        !ballin
        !duck
        !fries
        !hotdogs
        !onionrings
        !gj
        !bug
        !computers
        !done
        !false
        !totalfabrication
        !boost
        """

        {:ok, list}


      "!commands" ->
        # can we pull the list of commands automatically somehow?
        list = """
        !vr
        !donate
        !advice
        !sorry
        !thisisamazing
        !gohackyourself
        !next
        !wiki
        !tag
        !datafruiter
        !commands
        """

        {:ok, list}

      _ ->
        IO.puts("unhandled command: #{command}")
        # Elixir prefers two-element tuples esp. for :ok and :error
        {:error, :bad_command}
    end
  end

  defp play_video(video_path) do
    System.cmd("sh", ["-c", "mpv --vo=kitty --vo-kitty-alt-screen=no --vo-kitty-config-clear=no '#{video_path}' >> /tmp/honey_bucket.txt"])
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
