defmodule Otomai.Backend.UserRepoTest do
  use ExUnit.Case
  alias Otomai.User
  alias Otomai.Backend.UserRepo

  test "insert a user" do
    {:ok, repo} = UserRepo.start_link
    user = %User{id: 0, username: "test"}

    assert Dict.size(UserRepo.all(repo)) == 0

    new_user = UserRepo.insert(repo, user)

    all = UserRepo.all(repo)
    assert Dict.size(all) == 1
    assert(new_user.id == 1)
    assert(new_user.username == user.username)
  end

  test "update a user" do
    {:ok, repo} = UserRepo.start_link
    user = %User{id: 1, username: "test"}
    UserRepo.set_all(repo, %{1 => user})

    UserRepo.update(repo, %User{user | username: "lol"})

    all = UserRepo.all(repo)
    assert Dict.size(all) == 1
    assert Dict.fetch!(all, 1).username == "lol"
  end

  test "remove a user" do
    {:ok, repo} = UserRepo.start_link
    UserRepo.set_all(repo, %{1 => %User{id: 1, username: "test"}})

    UserRepo.remove(repo, 1)

    all = UserRepo.all(repo)
    assert Dict.size(all) == 0
  end

  test "find a user by its identifier" do
    {:ok, repo} = UserRepo.start_link
    user = %User{id: 1, username: "test"}
    UserRepo.set_all(repo, %{1 => user})

    {:ok, ^user} = UserRepo.find_by_id(repo, 1)
  end

  test "find a user by its username" do
    {:ok, repo} = UserRepo.start_link
    user = %User{id: 1, username: "test"}
    UserRepo.set_all(repo, %{1 => user})

    {:ok, ^user} = UserRepo.find_by_username(repo, "test")
  end
end
