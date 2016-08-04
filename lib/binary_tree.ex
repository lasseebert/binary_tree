defmodule BinaryTree do
  def new do
    nil
  end

  def insert(tree, key) do
    insert(tree, key, key)
  end
  def insert(nil, key, value) do
    {key, value, nil, nil}
  end
  def insert({root_key, root_value, left, right}, key, value) when key < root_key do
    {root_key, root_value, insert(left, key, value), right}
  end
  def insert({root_key, root_value, left, right}, key, value) when key > root_key do
    {root_key, root_value, left, insert(right, key, value)}
  end

  def search({key, value, _left, _right}, key), do: {:ok, value}
  def search(nil, key), do: {:error, :not_found}
  def search({root_key, _value, left, _right}, key) when key < root_key do
    search(left, key)
  end
  def search({root_key, _value, _left, right}, key) when key > root_key do
    search(right, key)
  end
end
