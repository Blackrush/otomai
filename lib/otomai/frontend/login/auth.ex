defmodule Otomai.Frontend.Login.Auth do
  use Otomai.Frontend.Base

  alias Otomai.Backend
  alias Otomai.Frontend.Login.Realm
  alias Otomai.User

  def handle(conn, msg) do
    [username, password] = String.split(msg, "\n#1", parts: 2)

    case Backend.find_user(username: username) |> authenticate(conn, password) do
      {:ok, user} ->
        conn |> Conn.set_behaviour(Realm)
             |> Conn.assign(:user, user)
             |> Conn.send ~w(Ad#{user.nickname}
                             Ac#{user.community}
                             AQ#{String.replace(user.secret_question, " ", "+")}
                             AlK#{if User.can?(user, :show, :console), do: 1, else: 0})
             |> Conn.send(Backend.find_realms |> format_host_list)

      {:error, :invalid_credentials} ->
        conn |> Conn.send("AlEf") |> Conn.close

      {:error, :not_enough_rights} ->
        conn |> Conn.send("AlEb") |> Conn.close

      {:error, _} ->
        # we didnt think of all cases, just close the connection for now
        Conn.close(conn)
    end
  end

  defp format_host(host) do
    id         = host.id
    state      = Realm.state(host)
    completion = Realm.completion(host)
    joinable   = if Realm.joinable?(host), do: "1", else: "0"

    "#{id};#{state};#{completion};#{joinable}"
  end

  defp format_host_list(hosts) do
    hosts |> Enum.map(&Auth.format_host/1)
          |> Enum.join("|")
  end

  defp authenticate(:not_found, _, _) do
    {:error, :invalid_credentials}
  end

  defp authenticate({:ok, user}, conn, password) do
    cond do
      not is_valid_password?(user, password, conn.assigns.ticket) ->
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
    Otomai.Crypto.decrypt(password, ticket)
  end

  defp cipher(password, _salt) do
    password # just return the clear password for now
  end

  defp compare_passwords(left, right) do
    left == right
  end
end
