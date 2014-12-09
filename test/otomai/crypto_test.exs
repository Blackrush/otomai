defmodule Otomai.CryptoTest do
  use ExUnit.Case
  alias Otomai.Crypto

  test "decrypt empty password and empty key" do
    assert Crypto.decrypt("", "") == ""
  end

  test "decrypt" do
    assert Crypto.decrypt("ZW54a81Y", "lsynipxrmpdfseoflkaomkibpziefaxv") == "test"
  end

  test "encrypt" do
    assert Crypto.encrypt("test", "lsynipxrmpdfseoflkaomkibpziefaxv") == "ZW54a81Y"
  end

  test "identity" do
    pass = "abcd"
    key  = "efgh"

    result = Crypto.encrypt(pass, key) |> Crypto.decrypt(key)

    assert result == pass
  end
end
