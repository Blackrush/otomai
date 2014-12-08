defmodule Otomai.Frontend.Login.Auth do
  use Otomai.Frontend.Base

  defhandler do
    [username, password] = String.split(msg, "\n#1", parts: 2)

    conn
      |> Conn.assign(:state, 2)
      |> Conn.assign(:user, %{username: username, password: password})
  end
end
