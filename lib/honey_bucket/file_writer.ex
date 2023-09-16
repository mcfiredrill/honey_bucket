defmodule HoneyBucket.FileWriter do
  require Logger

  def write message, color \\ "#ffff00" do
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
