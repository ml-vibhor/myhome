defmodule CategoriesRegistryServerTest do
  use ExUnit.Case, async: true

  doctest CategoriesRegistryServer

  setup do
    ## calls start_link function of module
    ## start_supervised : ExUnit will guarantee that the registry process will be shutdown before the next test starts
    cat_reg_server_pid = start_supervised!(CategoriesRegistryServer)
    %{cat_reg_server_pid: cat_reg_server_pid}
  end

  test "spawn a category and add item in category", %{cat_reg_server_pid: cat_reg_server_pid} do
    assert CategoriesRegistryServer.lookup(cat_reg_server_pid, "RATION") == :error

    ## starts a new agent process internally
    CategoriesRegistryServer.create(cat_reg_server_pid, "RATION")
    {:ok, cat_agent_pid} = CategoriesRegistryServer.lookup(cat_reg_server_pid, "RATION")

    ## now we can use Agent to set new items in the categories
    CategoriesAgent.set_cat_item(cat_agent_pid, "milk", "1 litre")
    assert CategoriesAgent.get_cat_item(cat_agent_pid, "milk") == "1 litre"

    CategoriesAgent.set_cat_item(cat_agent_pid, "tea powder", "1 kg")
    assert CategoriesAgent.get_cat_item(cat_agent_pid, "tea powder") == "1 kg"
  end
end
