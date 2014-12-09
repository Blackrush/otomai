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
    ticket = rand_ticket
    conn |> Conn.assign(:ticket, ticket)
         |> Conn.send("HC#{ticket}")
  end

  def handle(conn, "1.29.1") do
    Conn.set_behaviour(conn, Auth)
  end

  def handle(conn, _invalid) do
    conn |> Conn.send("AlEv1.29.1")
         |> Conn.close
  end

  defp rand_ticket(len \\ 32)

  defp rand_ticket(0) do
    <<>>
  end

  defp rand_ticket(len) do
    sigil = :random.uniform(26) + 96
    << sigil :: utf8,
       rand_ticket(len - 1) :: binary >>
  end
end
