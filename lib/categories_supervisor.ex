defmodule CategoriesSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {CategoriesRegistryServer, name: CategoriesRegistryServer}
    ]

    ## if a child dies, it will be the only one restarted
    Supervisor.init(children, strategy: :one_for_one)
  end
end
