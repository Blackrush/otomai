defmodule GenGenServer do
  defmacro __using__(_opts \\ []) do
    quote do
      import GGServer
      @behaviour :gen_server
    end
  end

  def start_link(mod, args, opts) do
    :gen_server.start_link(mod, args, opts)
  end

  def call(ref, req, timeout \\ :infinity) do
    :gen_server.call(ref, req, timeout)
  end

  def cast(ref, req) do
    :gen_server.cast(ref, req)
  end

  defmacro initialize(args \\ nil, do: block) do
    args = args || Macro.var(:_, nil)

    quote do
      def init(unquote(args)) do
        unquote(block)
      end
    end
  end

  defmacro defcast(signature, do: block) do
    pattern = signature_to_tuple(signature)
    params  = signature_params(signature)
    {event, _, _} = signature

    quote do
      def unquote(event)(ref, unquote_splicing(params)) do
        :gen_server.cast(ref, [unquote_splicing(params)])
      end

      def handle_cast(unquote(pattern), var!(state)) do
        unquote(block)
      end
    end
  end

  defmacro defcall(signature, do: block) do
    pattern = signature_to_tuple(signature)
    params  = signature_params(signature)
    {event, _, _} = signature

    quote do
      def unquote(event)(ref, unquote_splicing(params), timeout \\ :infinity) do
        :gen_server.call(ref, [unquote_splicing(params)], timeout)
      end

      def handle_call(unquote(pattern), var!(state)) do
        unquote(block)
      end
    end
  end

  defp signature_to_tuple({:when, _, [signature, _clause]}) do
    signature_to_tuple(signature)
  end

  defp signature_to_tuple({event, _, params}) when is_list(params) do
    quote do: {unquote(event), unquote_splicing(params)}
  end

  defp signature_to_tuple({event, _, _}) do
    event
  end

  defp signature_params({_, _, params}) when is_list(params) do
    params
  end

  defp signature_params({_, _, _}) do
    []
  end

  defp signature_clause({:when, _, [_signature, clause]}) do
    clause
  end

  defp signature_clause({_, _, _}) do
    nil
  end
end
