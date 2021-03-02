defmodule CategoriesSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      ## note there is no module named 'CategoriesAgentSupervisor'
      {DynamicSupervisor, name: CategoriesAgentSupervisor, strategy: :one_for_one},
      {CategoriesRegistryServer, name: CategoriesRegistryServer}
    ]

    ## if a child dies, it will be the only one restarted
    Supervisor.init(children, strategy: :one_for_all)
  end
end
