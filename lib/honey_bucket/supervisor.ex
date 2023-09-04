defmodule HoneyBucket.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts) do
    Logger.debug "hey"
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    [bot_config] = Application.fetch_env!(:honey_bucket, :bots)
    Logger.debug(bot_config)

    children = [
      {TMI.Supervisor, bot_config}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
