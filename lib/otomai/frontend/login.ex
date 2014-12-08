defmodule Otomai.Frontend.Login do
  use Otomai.Frontend.Base

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
