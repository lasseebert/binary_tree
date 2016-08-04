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

  def search(nil, _key), do: {:error, :not_found}
  def search({key, value, _left, _right}, key), do: {:ok, value}
  def search({root_key, _value, left, _right}, key) when key < root_key do
    search(left, key)
  end
  def search({root_key, _value, _left, right}, key) when key > root_key do
    search(right, key)
  end

  def delete(nil, _key), do: nil
  def delete({key, _value, nil, nil}, key), do: nil
  def delete({key, _value, left, nil}, key), do: left
  def delete({key, _value, nil, right}, key), do: right
  def delete({key, _value, left, right}, key) do
    {pre_key, pre_value, _left, _right} = max(left)
    {pre_key, pre_value, delete(left, pre_key), right}
  end
  def delete({root_key, value, left, right}, key) when key < root_key do
    {root_key, value, delete(left, key), right}
  end
  def delete({root_key, value, left, right}, key) when key > root_key do
    {root_key, value, left, delete(right, key)}
  end

  defp max({_k, _v, _left, nil} = tree), do: tree
  defp max({_k, _v, _left, right}), do: max(right)
end
