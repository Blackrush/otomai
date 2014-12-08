defmodule Otomai.Frontend.Behaviour do
  use Behaviour
  alias Otomai.Frontend.Conn

  @doc "When a connection is created."
  defcallback connect(conn :: Conn.t) :: Conn.t

  @doc "When a connection is destroyed."
  defcallback disconnect(conn :: Conn.t) :: Conn.t

  @doc "When a connection receives data."
  defcallback handle(conn :: Conn.t, data :: binary) :: Conn.t
end
