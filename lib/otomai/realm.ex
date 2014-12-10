defmodule Otomai.Realm do
  @type t :: %__MODULE__{}

  defstruct id: 0

  def state(realm) do
    1
  end

  def completion(realm) do
    75
  end

  def joinable?(realm) do
    true
  end
end
