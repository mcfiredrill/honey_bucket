defmodule HoneyBucket.Tmi do
  use TMI

  @impl TMI.Handler
  def handle_message(message, sender, channel, tags) do
    Logger.debug tags
    color = Map.new(tags)["color"]
    Logger.debug color
    Logger.debug("running toilet")
    { toilet_output, _exit_code } = System.cmd("figlet", ["-f", "small", "#{sender}: #{message}"])
    Logger.debug("Message in #{channel} from #{sender}: #{message}")
  end

  defp write_to_file message, color do
    {:ok, file } = File.open "/tmp/honey_bucket.txt", [:append]
    { red, _ } = color
      |> String.slice(1..-1)
      |> String.slice(0..1)
      |> Integer.parse(16)
    { green, _ } = color
      |> String.slice(1..-1)
      |> String.slice(2..3)
      |> Integer.parse(16)
    { blue, _ } = color
      |> String.slice(1..-1)
      |> String.slice(4..5)
      |> Integer.parse(16)
    Logger.debug "red: #{red}"
    Logger.debug "blue: #{blue}"
    Logger.debug "green: #{green}"
    IO.binwrite file, "\x1b[38;2;#{red};#{green};#{blue}m#{message}\x1b[0m"
  end
end
