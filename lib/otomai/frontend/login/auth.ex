defmodule Otomai.Frontend.Login.Auth do
  use Otomai.Frontend.Base

  alias Otomai.Frontend.Login.Realm

  def handle(conn, msg) do
    [username, password] = String.split(msg, "\n#1", parts: 2)

    conn |> Conn.set_behaviour(Realm)
         |> Conn.assign(:user, %{username: username, password: password})
  end
end
