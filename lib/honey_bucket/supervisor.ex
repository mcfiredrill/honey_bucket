defmodule HoneyBucket.Supervisor do
  use Supervisor
  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    [bot_config] = Application.fetch_env!(:honey_bucket, :bots)

    children = [
      {TMI.Supervisor, bot_config},
      {HoneyBucket.WebSocket, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
