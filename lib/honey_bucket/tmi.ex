defmodule HoneyBucket.Tmi do
  use TMI

  @impl TMI.Handler
  def handle_message(message, sender, channel, tags) do
    Logger.debug tags
    color = Map.new(tags)["color"]
    Logger.debug color
    Logger.debug("running toilet")
    { toilet_output, _exit_code } = System.cmd("figlet", ["-f", "small", "#{sender}: #{message}"])
    HoneyBucket.FileWriter.write toilet_output, color
    Logger.debug("Message in #{channel} from #{sender}: #{message}")
  end
end
