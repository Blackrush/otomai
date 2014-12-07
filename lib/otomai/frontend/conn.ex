defmodule Otomai.Frontend.Conn do
  @moduledoc """
    A module describing a connection.
  """
  @type t :: __MODULE__

  alias __MODULE__, as: T

  defstruct handle:    nil,
            adapter:   nil,
            behaviour: nil,
            halted:    false,
            assigns:   %{}

  @doc """
    Send data to a connection.
  """
  @spec send(conn :: t, data :: binary) :: Conn.t
  def send(conn, data)

  def send(conn = %T{halted: false}, data) do
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
end
