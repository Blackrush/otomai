defmodule Otomai.Frontend.Conn do
  @moduledoc """
    A module describing a connection.
  """
  @type t :: __MODULE__

  require Logger
  alias __MODULE__, as: T

  defstruct handle:    nil,
            adapter:   nil,
            behaviour: nil,
            halted:    false,
            assigns:   %{state: 0}

  @doc """
    Send data to a connection.
  """
  @spec send(conn :: t, data :: [binary] | binary) :: Conn.t
  def send(conn, data)

  def send(conn = %T{halted: false}, list) when is_list(list) do
    Logger.debug "SND #{inspect list}"
    do_send(conn, Enum.join(list, "\0") <> "\0")
  end

  def send(conn = %T{halted: false}, data) do
    Logger.debug "SND #{data}"
    do_send(conn, data <> "\0")
  end

  defp do_send(conn, data) do
    :ok = conn.adapter.send(conn.handle, data)
    conn
  end

  def send(conn, _) do
    conn
  end

  @doc """
    Receive data from a connection.
  """
  @spec recv(conn :: t) :: {:ok, binary} | {:error, term}
  def recv(conn)

  def recv(conn = %T{halted: false}) do
    conn.adapter.recv(conn.handle, 0, :infinity)
  end

  def recv(_conn) do
    {:error, :halted}
  end

  @doc """
    Close a connection.
  """
  @spec close(conn :: t) :: t
  def close(conn) do
    :ok = conn.adapter.close(conn.handle)
    %T{conn | halted: true}
  end

  @doc """
    Assign an attribute to a connection.
  """
  @spec assign(t, atom, term) :: t
  def assign(conn, key, value) do
    assigns = Map.put(conn.assigns, key, value)
    %T{conn | assigns: assigns}
  end

  @doc """
    Set the behaviour of a connection.
  """
  @spec set_behaviour(t, module) :: t
  def set_behaviour(conn, behaviour) do
    %T{conn | behaviour: behaviour}
  end
end
