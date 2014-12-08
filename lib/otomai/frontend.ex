defmodule Otomai.Frontend do
  def start_link(opts) do
    Otomai.Frontend.Base.start_link(opts)
  end
end
