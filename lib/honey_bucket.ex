defmodule HoneyBucket do
  def start(_type, _args) do
    HoneyBucket.Supervisor.start_link(name: HoneyBucket.Supervisor)
  end
end
