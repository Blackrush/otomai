defmodule Otomai.Frontend.Login do
  use Otomai.Frontend.Base

  alias Otomai.Frontend.Login.Auth

  def start_link(config) do
    Otomai.Frontend.start_link port:      config[:port],
                               listeners: config[:listeners],
                               name:      __MODULE__,
                               behaviour: __MODULE__
  end

  def connect(conn) do
    Conn.send(conn, "HCabcdefghijklmnopqrstuvwxyz098765")
  end

  def handle(conn, "1.29.1") do
    Conn.set_behaviour(conn, Auth)
  end

  def handle(conn, _invalid) do
    conn |> Conn.send("AlEv1.29.1")
         |> Conn.close
  end
end
