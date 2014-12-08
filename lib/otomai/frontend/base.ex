defmodule Otomai.Frontend.Base do
  defmacro __using__(_opts \\ []) do
    quote do
      @behaviour Otomai.Frontend.Behaviour

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
end
