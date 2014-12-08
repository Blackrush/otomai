defmodule Otomai.Frontend do
  def start_link(opts) do
    Otomai.Frontend.Adapters.Ranch.start_link(opts)
  end
end
