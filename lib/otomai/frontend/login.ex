defmodule Otomai.Frontend.Login do
  use Otomai.Frontend.Base

  def start_link(config) do
    Otomai.Frontend.start_link port:      config[:port],
                               listeners: config[:listeners],
                               name:      __MODULE__,
                               behaviour: __MODULE__
  end

  def connect(conn) do
    Conn.send(conn, "HCabcdefghijklmnopqrstuvwxyz098765")
  end

  ## Version check
  defhandler state: 0 do
    case msg do
      "1.29.1" ->
        Conn.assign(conn, :state, 1)

      _invalid ->
        conn
          |> Conn.send("AlEv1.29.1")
          |> Conn.close
    end
  end

  forward Auth, state: 1
  forward Realm, state: 2
end
