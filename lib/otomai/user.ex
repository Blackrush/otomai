defmodule Otomai.User do
  @type t :: %User{}

  defstruct username:        "",
            password:        "",
            salt:            "",
            nickname:        "",
            secret_question: "",
            secret_answer:   "",
            community:       0

  @spec can?(user :: t, action :: atom, subject :: term | nil) :: bool
  def can?(user, action, subject \\ nil) do
    raise "todo"
  end

  @spec cannot?(user :: t, action :: atom, subject :: term | nil) :: bool
  def cannot?(user, action, subject \\ nil) do
    not can?(user, action, subject)
  end

end
