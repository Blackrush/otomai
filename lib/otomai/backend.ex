defmodule Otomai.Backend do
  alias Otomai.User
  alias Otomai.Backend.UserRepo
  alias Otomai.Backend.RealmRegistry

  def find_user([id: id]) do
    UserRepo.find_by_id(UserRepo, id)
  end

  def find_user([username: username]) do
    UserRepo.find_by_username(UserRepo, username)
  end

  def find_realm([id: id]) do
    RealmRegistry.find_by_id(RealmRegistry, id)
  end

  def find_realms do
    RealmRegistry.find_all(RealmRegistry)
  end

  def insert(user = %User{}) do
    UserRepo.insert(UserRepo, user)
  end

  def update(user = %User{}) do
    UserRepo.update(UserRepo, user)
  end
end
