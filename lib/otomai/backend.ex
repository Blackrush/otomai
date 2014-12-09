defmodule Otomai.Backend do
  alias Otomai.User
  alias Otomai.Backend.UserRepo

  def find_user([id: id]) do
    UserRepo.find_by_id(UserRepo, id)
  end

  def find_user!([username: username]) do
    UserRepo.find_by_username(UserRepo, username)
  end

  def insert(user = %User{}) do
    UserRepo.insert(UserRepo, user)
  end

  def update(user = %User{}) do
    UserRepo.update(UserRepo, user)
  end
end
