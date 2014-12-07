defmodule Otomai.Frontend.BaseUtils do 
  defmacro forward(mod, opts) do
    prefix = Keyword.get(opts, :prefix)

    conn = case opts[:state] do
      nil ->
        Macro.var(:conn, nil)

      state ->
        quote do
          conn = %Conn{state: unquote(state)}
        end
    end

    quote do
      def handle(unquote(conn), unquote(prefix) <> rest) do
        unquote(mod).handle(var!(conn), rest)
      end
    end
  end

  defmacro defhandler(prefix, opts) do
    block = Keyword.get(opts, :do)

    conn = case opts[:state] do
      nil ->
        Macro.var(:conn, nil)

      state ->
        quote do
          var!(conn) = %Conn{state: unquote(state)}
        end
    end

    quote do
      def handle(unquote(conn), unquote(prefix) <> var!(msg)) do
        unquote(block)
      end
    end
  end

end
