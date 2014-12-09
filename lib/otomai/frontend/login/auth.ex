defmodule Otomai.Frontend.Login.Auth do
  use Otomai.Frontend.Base

  alias Otomai.Backend
  alias Otomai.Frontend.Login.Realm

  def handle(conn, msg) do
    [username, password] = String.split(msg, "\n#1", parts: 2)

    case Backend.find_user!(username: username) |> authenticate(conn, password) do
      {:ok, user} ->
        conn |> Conn.set_behaviour(Realm)
             |> Conn.assign(:user, user)
             |> Conn.send ~w(
                Ad#{user.nickname}
                Ac#{user.community}
                AH1;1;75;1
                AlK#{if User.can?(user, :show, :console), do: 1, else: 0}
                AQ#{String.replace(user.secret_question, " ", "+")}
             )

      {:error, :invalid_credentials} ->
        conn |> Conn.send("AlEf") |> Conn.close

      {:error, :not_enough_rights} ->
        conn |> COnn.send("AlEb") |> Conn.close

      {:error, _} ->
        # we didnt think of all cases, just close the connection for now
        Conn.close(conn)
    end
  end

  defp authenticate(user, conn, password) do
    cond do
      user == :not_found || not is_valid_password?(user, password, conn.assigns.ticket) ->
        {:error, :invalid_credentials}
      User.cannot?(user, :authenticate) ->
        {:error, :not_enough_rights}
      true ->
        {:ok, user}
    end
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
