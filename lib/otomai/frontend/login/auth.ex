defmodule Otomai.Frontend.Login.Auth do
  use Otomai.Frontend.Base

  alias Otomai.Backend
  alias Otomai.Frontend.Login.Realm

  def handle(conn, msg) do
    [username, password] = String.split(msg, "\n#1", parts: 2)

    user = Backend.find_user!(username: username) |> authenticate!(conn, password)

    conn |> Conn.set_behaviour(Realm)
         |> Conn.assign(:user, user)
  end

  defp authenticate!(user, conn, password) do
    unless is_valid_password?(user, password, conn.assigns.ticket) do
      raise "invalid password"
    end

    if User.cannot?(user, :authenticate) do
      raise "cannot authenticate"
    end

    user
  end

  defp is_valid_password?(user, password, ticket) do
    password |> decode_password(ticket)
             |> cipher(user.salt)
             |> compare_passwords(user.password)
  end

  defp decode_password(password, ticket) do
    raise "todo"
  end

  defp cipher(password, salt) do
    raise "todo"
  end

  defp compare_passwords(left, right) do
    raise "todo"
  end
end
