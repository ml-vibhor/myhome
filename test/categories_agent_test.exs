defmodule CategoriesAgentTest do
  use ExUnit.Case, async: true
  doctest CategoriesAgent

  setup %{} do
    {:ok, cat_agent_pid} = CategoriesAgent.start_link([])
    %{cat_agent_pid: cat_agent_pid}
  end

  test "get a category value", %{cat_agent_pid: cat_agent_pid} do
    assert CategoriesAgent.get_cat_item(cat_agent_pid, "Ration") == nil
  end

  test "set a category value", %{cat_agent_pid: cat_agent_pid} do
    CategoriesAgent.set_cat_item(cat_agent_pid, "Ration", "rice")
    assert CategoriesAgent.get_cat_item(cat_agent_pid, "Ration") == "rice"
  end

  test "delete cat and set new", %{cat_agent_pid: cat_agent_pid} do
    CategoriesAgent.delete_cat_item(cat_agent_pid, "Ration")
    assert CategoriesAgent.get_cat_item(cat_agent_pid, "Ration") == nil
  end
end
