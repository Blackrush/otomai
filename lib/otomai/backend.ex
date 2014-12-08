defmodule Otomai.Backend do
  alias Otomai.Backend.UserRepo

  def find_user!([id: id]) do
    {:ok, user} = UserRepo.find_by_id(UserRepo, id)
    user
  end

  def find_user!([username: username]) do
    {:ok, user} = UserRepo.find_by_username(UserRepo, username)
    user
  end

  def insert(user = %User{}) do
    UserRepo.insert(UserRepo, user)
  end

  def update(user = %User{}) do
    UserRepo.update(UserRepo, user)
  end
end
