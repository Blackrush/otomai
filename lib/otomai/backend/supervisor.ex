defmodule Otomai.Backend.Supervisor do
  use Supervisor

  def start_link(config) do
    Supervisor.start_link __MODULE__, [config]
  end

  def init(config) do
    supervise children(config),
      name:     Otomai.Backend.Supervisor,
      strategy: :one_for_one
  end

  defp children(config) do
    [
      worker(Otomai.Backend.UserRepo,      [nil, [name: {:local, Otomai.Backend.UserRepo}]]),
      worker(Otomai.Backend.RealmRegistry, [nil, [name: {:local, Otomai.Backend.RealmRegistry}]]),
    ]
  end
end
