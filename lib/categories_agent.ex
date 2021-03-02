defmodule CategoriesAgent do
  use Agent, restart: :temporary

  def start_link(opts) do
    Agent.start_link(fn -> %{} end, opts)
  end

  def get_cat_item(cat_agent_pid, cat_name) do
    # &1 => current state
    Agent.get(cat_agent_pid, &Map.get(&1, cat_name))
  end

  def set_cat_item(cat_agent_pid, cat_name, cat_value) do
    Agent.update(cat_agent_pid, &Map.put(&1, cat_name, cat_value))
  end

  def delete_cat_item(cat_agent_pid, cat_name) do
    Agent.get_and_update(cat_agent_pid, &Map.pop(&1, cat_name))
  end
end
