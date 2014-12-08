defmodule Otomai.Frontend.BaseUtils do
  alias Otomai.Frontend.Conn

  defmacro forward(mod, opts \\ []) do
    block = quote do
      unquote(mod).handle(var!(conn), var!(msg))
    end

    gen_handler(opts, block)
  end

  defmacro defhandler(opts \\ [], block)

  defmacro defhandler(opts, do: block) when is_list(opts) do
    gen_handler(opts, block)
  end

  defmacro defhandler(prefix, do: block) when is_binary(prefix) do
    gen_handler([prefix: prefix], block)
  end

  defp gen_handler(opts, block) do
     msg = case opts[:prefix] do
      nil ->
        Macro.var(:msg, nil)

      prefix ->
        quote do
          unquote(prefix) <> var!(msg)
        end
    end

    conn = case opts[:state] do
      nil ->
        Macro.var(:conn, nil)

      state ->
        quote do
          var!(conn) = %Conn{assigns: %{state: unquote(state)}}
        end
    end

    quote do
      def handle(unquote(conn), unquote(msg)) do
        unquote(block)
      end
    end
  end

end
