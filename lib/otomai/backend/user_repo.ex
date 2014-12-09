defmodule Otomai.Backend.UserRepo do
  use GenGenServer
  require Logger
  alias Otomai.User

  defmodule State do
    defstruct next_id: 1,
              registry: %{}
  end

  initialize do
    {:ok, %State{}}
  end

  @doc """
    Insert a user in the repository and give it a unique identifier.
  """
  #spec insert(user :: Otomai.User.t) :: Otomai.User.t
  defcall insert(user) do
    new_id = state.next_id
    new_user = %User{user | id: new_id}

    new_registry = Dict.put_new(state.registry, new_id, new_user)

    {:reply, new_user, %State{next_id: new_id + 1, registry: new_registry}}
  end

  @doc """
    Update a user from the repository.
  """
  #spec update(user :: Otomai.User.t) :: nil
  defcast update(user) do
    new_registry = Dict.put(state.registry, user.id, user)
    {:noreply, %State{state | registry: new_registry}}
  end

  @doc """
    Remove a user from the repository.
  """
  #spec remove(user :: Otomai.User.t | integer) :: nil
  defcast remove(user) do
    id = if is_integer(user), do: user, else: user.id
    new_registry = Dict.delete(state.registry, id)
    {:noreply, %State{state | registry: new_registry}}
  end

  @doc """
    Find a user in the repository using its identifier.
  """
  #spec find_by_id(id :: integer) :: {:ok, Otomai.User.t} | :not_found
  defcall find_by_id(id) do
    case Dict.fetch(state.registry, id) do
      {:ok, user} ->
        {:reply, {:ok, user}, state}
      :error ->
        {:reply, :not_found, state}
    end
  end

  @doc """
    Find a user in the repository using its username.
  """
  #spec find_by_username(username :: String.t) :: {:ok, Otomai.User.t} | :not_found
  defcall find_by_username(username) do
    user = state.registry |> Dict.values
                          |> Enum.find(fn(x) -> x.username == username end)

    case user do
      nil ->
        {:reply, :not_found, state}

      _ ->
        {:reply, {:ok, user}, state}
    end
  end

  @doc false
  #spec all() :: %{integer => Otomai.User.t}
  defcall all do
    {:reply, state.registry, state}
  end

  @doc false
  #spec set_all(new_state :: %{integer => Otomai.User.t}) :: nil
  defcall set_all(new_registry) do
    {:reply, nil, %State{state | registry: new_registry}}
  end
end
