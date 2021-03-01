defmodule CategoriesTest do
  use ExUnit.Case, async: true
  doctest Categories

  setup %{} do
    {:ok, cat_agent_pid} = Categories.start_link([])
    %{cat_agent_pid: cat_agent_pid}
  end

  test "get a category value", %{cat_agent_pid: cat_agent_pid} do
    assert Categories.get_cat_item(cat_agent_pid, "Ration") == nil
  end

  test "set a category value", %{cat_agent_pid: cat_agent_pid} do
    Categories.set_cat_item(cat_agent_pid, "Ration", "rice")
    assert Categories.get_cat_item(cat_agent_pid, "Ration") == "rice"
  end

  test "delete cat and set new", %{cat_agent_pid: cat_agent_pid} do
    Categories.delete_cat_item(cat_agent_pid, "Ration")
    assert Categories.get_cat_item(cat_agent_pid, "Ration") == ni
  end
end
