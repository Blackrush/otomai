defmodule Otomai.Supervisor do
  use Supervisor

  def start_link(config) do
    Supervisor.start_link __MODULE__, config
  end

  def init(config) do
    supervise children(config),
      name: __MODULE__,
      strategy: :one_for_one
  end

  defp children(_config) do
    [

    ]
  end
end
