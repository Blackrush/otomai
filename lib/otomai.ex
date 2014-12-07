defmodule Otomai do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    config = Mix.Config.read!("config/config.exs")

    Otomai.Supervisor.start_link(config)
  end
end
