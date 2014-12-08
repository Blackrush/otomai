defmodule Otomai.Frontend.Base do
  require Logger
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

      def connect(conn) do
        conn
      end

      def disconnect(conn) do
        conn
      end

      defoverridable [handle: 2, connect: 1, disconnect: 1]
    end
  end

  defcallback connect(conn :: Conn.t) :: Conn.t
  defcallback disconnect(conn :: Conn.t) :: Conn.t
  defcallback handle(conn :: Conn.t, data :: binary) :: Conn.t

  def start_link(opts) do
    name      = Keyword.get(opts, :name)
    listeners = Keyword.get(opts, :listeners)
    port      = Keyword.get(opts, :port)
    behaviour = Keyword.get(opts, :behaviour)

    Logger.info "#{name} will listen on #{port} using #{listeners} workers"

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

    Logger.debug "OPN"
    
    %Conn{adapter: transport, handle: socket, behaviour: behaviour}
      |> behaviour.connect
      |> loop
  end

  defp loop(conn = %Conn{halted: false}) do
    case Conn.recv(conn) do
      {:ok, data} ->
        data |> tokenize |> execute(conn) |> loop
      _ ->
        Conn.close(conn) |> loop
    end
  end

  defp loop(conn) do
    conn.behaviour.disconnect(conn)
    Logger.debug "CLS"
    :ok
  end

  defp tokenize(data) do
    String.split(data, "\n\0")
  end

  defp execute([], conn) do
    conn
  end

  defp execute(["" | rest], conn) do
    execute(rest, conn)
  end

  defp execute([data | rest], conn = %Conn{halted: false}) do
    Logger.debug "RCV #{data}"
    execute(rest, conn.behaviour.handle(conn, data))
  end

  defp execute(_xs, conn) do
    conn
  end
end
