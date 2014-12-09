defmodule Otomai.Backend.UserRepo do
  use GenGenServer
  require Logger

  initialize do
    {:ok, %{}}
  end

  @doc """
    Insert a user in the repository.
  """
  #spec insert(user :: Otomai.User.t) :: nil
  defcast insert(user) do
    new_state = Dict.put_new(state, user.id, user)
    {:noreply, new_state}
  end

  @doc """
    Update a user from the repository.
  """
  #spec update(user :: Otomai.User.t) :: nil
  defcast update(user) do
    new_state = Dict.put(state, user.id, user)
    {:noreply, new_state}
  end

  @doc """
    Remove a user from the repository.
  """
  #spec remove(user :: Otomai.User.t | integer) :: nil
  defcast remove(user) do
    new_state = Dict.delete(state, (if is_integer(user), do: user, else: user.id))
    {:noreply, new_state}
  end

  @doc """
    Find a user in the repository using its identifier.
  """
  #spec find_by_id(id :: integer) :: {:ok, Otomai.User.t} | :not_found
  defcall find_by_id(id) do
    case Dict.fetch(state, id) do
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
    user = state |> Dict.values
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
    {:reply, state, state}
  end

  @doc false
  #spec set_all(new_state :: %{integer => Otomai.User.t}) :: nil
  defcall set_all(new_state) do
    {:reply, nil, new_state}
  end
end
