defmodule Otomai.Frontend.Base do
  use Behaviour

  alias Otomai.Frontend.Conn

  defmacro __using__(_opts \\ []) do
    quote do
      @behaviour Otomai.Frontend.Base

      import Otomai.Frontend.BaseUtils
      alias Otomai.Frontend.Conn

      def handle(conn, _data) do
        conn
      end

      defoverridable [handle: 2]
    end
  end

  defcallback handle(conn :: Conn.t, data :: binary) :: Conn.t

  def start_link(opts) do
    name      = Keyword.get(opts, :name)
    listeners = Keyword.get(opts, :listeners)
    port      = Keyword.get(opts, :port)
    behaviour = Keyword.get(opts, :behaviour)

    :ranch.start_listener name,
      listeners,
      :ranch_tcp,
      [port: port],
      __MODULE__,
      [behaviour: behaviour]
  end

  def start_link(ref, socket, transport, [behaviour: behaviour]) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, behaviour])
    {:ok, pid}
  end

  def init(ref, socket, transport, behaviour) do
    :ok = :ranch.accept_ack(ref)
    
    conn = %Conn{adapter: transport, handle: socket, behaviour: behaviour}
    loop(conn)
  end

  defp loop(conn = %Conn{halted: false}) do
    case Conn.recv(conn) do
      {:ok, data} ->
        conn.behaviour.handle(conn, data) |> loop
      _ ->
        :ok
    end
  end

  defp loop(_conn) do
    :ok
  end
end
