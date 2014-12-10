defmodule Otomai.Backend.RealmRegistry do
  use GenGenServer

  defmodule State do
    defstruct registry: %{}
  end

  initialize do
    {:ok, %State{}}
  end

  defcall find_all do
    realms = Dict.values(state.registry)

    {:reply, realms, state}
  end

  defcall find_by_id(id) do
    case Dict.fetch(state.registry, id) do
      {:ok, realm} ->
        {:reply, {:ok, realm}, state}

      :error ->
        {:reply, :not_found, state}
    end
  end

  defcall register(pid, id) do
    if Dict.has_key?(state.registry, id) do
      new_registry = Dict.put(state.registry, id, pid)
    else
      {:reply, {:error, :already_registered}, state}
    end
  end
end
