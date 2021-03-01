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
    cat_names_and_cat_agent_pids_map = %{}
    cat_names_and_monitor_refs_map = %{}
    {:ok, {cat_names_and_cat_agent_pids_map, cat_names_and_monitor_refs_map}}
  end

  @impl true
  def handle_call({:lookup, cat_name}, _from, registry_state) do
    {cat_names_and_cat_agent_pids_map, _} = registry_state
    {:reply, Map.fetch(cat_names_and_cat_agent_pids_map, cat_name), registry_state}
  end

  @impl true
  def handle_cast({:create, cat_name}, registry_state) do
    {cat_names_and_cat_agent_pids_map, cat_names_and_monitor_refs_map} = registry_state
    ## check if key already exists in our registry
    if(Map.has_key?(cat_names_and_cat_agent_pids_map, cat_name)) do
      {:noreply, registry_state}
    else
      ## start a new agent process for this cat and add the pid <=> cat_name map in our registry
      {:ok, cat_agent_pid} = CategoriesAgent.start_link([])

      ## monitor this agent process
      ref_id = Process.monitor(cat_agent_pid)

      ## update the cat name vs registry pid map
      cat_names_and_cat_agent_pids_map =
        Map.put(cat_names_and_cat_agent_pids_map, cat_name, cat_agent_pid)

      ## update the ref id vs cat name
      cat_names_and_monitor_refs_map = Map.put(cat_names_and_monitor_refs_map, ref_id, cat_name)

      {:noreply, {cat_names_and_cat_agent_pids_map, cat_names_and_monitor_refs_map}}
    end
  end

  @impl true
  def handle_info(
        {:DOWN, ref, :process, _pid, _reason},
        {cat_names_and_cat_agent_pids_map, cat_names_and_monitor_refs_map}
      ) do
    ## update registry in case an agent is stopped

    ## using the reference id we 'pop' the category name,
    {cat_name, cat_names_and_monitor_refs_map} = Map.pop(cat_names_and_monitor_refs_map, ref)

    ## using 'cat_name' we delete the entry in 'cat_names_and_cat_agent_pids_map'
    cat_names_and_cat_agent_pids_map = Map.delete(cat_names_and_cat_agent_pids_map, cat_name)

    ## set updated state of the registry
    {:noreply, {cat_names_and_cat_agent_pids_map, cat_names_and_monitor_refs_map}}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # @impl true
  # def handle_call({:delete, cat_name}, _from, cat_registry) do
  #     if(Map.has_key?(cat_registry, cat_name)) do
  #       Map.pop(cat_registry, cat_name)
  #       {:reply, :ok}
  #     end
  # end
end
