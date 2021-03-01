defmodule CategoriesRegistryServer do
  @doc """
  Motovation: Agents alone cannot provide enough functionality to deal with client/server setup.
  It is good practice to put generic server functionalities in a seperate process. For this, we will need
  a registry of the agent process vs category names so that we can initialize agents dynamically thereby maintaining a map.
  Hence, we are implementing a Genserver for our categories module
  Here we will implement the client APIs and the Genserver callback
  Our implementation will ensure that agents are dynamically created, monitored and thh registry is always available.
  """

  use GenServer

  ## implement client APIs

  @doc """
  Start registry server process
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def lookup(cat_reg_pid, cat_name) do
    GenServer.call(cat_reg_pid, {:lookup, cat_name})
  end

  def create(cat_reg_pid, cat_name) do
    GenServer.cast(cat_reg_pid, {:create, cat_name})
  end

  ## implement GenServer callbacks

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, cat_name}, _from, cat_registry) do
    {:reply, Map.fetch(cat_registry, cat_name), cat_registry}
  end

  @impl true
  def handle_cast({:create, cat_name}, cat_registry) do
    ## check if key already exists in our registry
    if(Map.has_key?(cat_registry, cat_name)) do
      {:noreply, cat_registry}
    else
      ## start a new agent process for this cat and add the pid <=> cat_name map in our registry
      {:ok, cat_agent_pid} = CategoriesAgent.start_link([])
      {:noreply, Map.put(cat_registry, cat_name, cat_agent_pid)}
    end
  end

  # @impl true
  # def handle_call({:delete, cat_name}, _from, cat_registry) do
  #     if(Map.has_key?(cat_registry, cat_name)) do
  #       Map.pop(cat_registry, cat_name)
  #       {:reply, :ok}
  #     end
  # end
end
