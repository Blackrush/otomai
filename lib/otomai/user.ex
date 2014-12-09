defmodule Otomai.User do
  @type t :: %__MODULE__{}

  defstruct id:              0,
            username:        "",
            password:        "",
            salt:            "",
            nickname:        "",
            secret_question: "",
            secret_answer:   "",
            community:       0

  @spec can?(user :: t, action :: atom, subject :: term | nil) :: boolean
  def can?(_user, _action, _subject \\ nil) do
    raise "todo"
  end

  @spec cannot?(user :: t, action :: atom, subject :: term | nil) :: boolean
  def cannot?(user, action, subject \\ nil) do
    not can?(user, action, subject)
  end

end
