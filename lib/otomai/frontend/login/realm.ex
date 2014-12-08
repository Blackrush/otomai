defmodule Otomai.Frontend.Login.Realm do
  use Otomai.Frontend.Base

  ## Queue
  defhandler "Af" do
    conn |> Conn.send("Af1;1;1;1;1")
  end

  ## Character list
  defhandler "Ax" do
    raise "todo"
  end

  ## Server selection
  defhandler "AX" do
    raise "todo"
  end
end
