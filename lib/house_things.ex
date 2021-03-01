defmodule HouseThings do
  use Application

  @doc """
  The goal of start/2 is to start a supervisor,
  which will then start any child services or execute any other code our application may need
  """
  @impl true
  def start(_type, _args) do
    CategoriesSupervisor.start_link(name: CategoriesSupervisor)
  end

  @moduledoc """
  Documentation for `HouseThings`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HouseThings.hello()
      :world

  """
  # def hello do
  #   :world
  # end
end
