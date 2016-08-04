defmodule BinaryTree do
  @moduledoc """
  A binary search tree

  The structure of each node is:
  {key, value, left, right}
  nil is an empty tree
  """

  def new do
    nil
  end

  @doc """
  Inserts a node with value equal to its key
  """
  def insert(tree, key) do
    insert(tree, key, key)
  end

  @doc """
  Inserts a new node in the tree
  """
  # Insertion into an empty tree
  def insert(nil, key, value) do
    {key, value, nil, nil}
  end

  # Replace existing key with new value
  def insert({key, _root_value, left, right}, key, value) do
    {key, value, left, right}
  end

  # Insert in left subtree
  def insert({root_key, root_value, left, right}, key, value) when key < root_key do
    {root_key, root_value, insert(left, key, value), right}
  end

  # Insert in right subtree
  def insert({root_key, root_value, left, right}, key, value) when key > root_key do
    {root_key, root_value, left, insert(right, key, value)}
  end

  @doc """
  Searches for a key in the tree, returns {:ok, value} if found and
  {:error, :not_found} otherwise
  """
  # Search in empty tree
  def search(nil, _key), do: {:error, :not_found}

  # Search in tree with root key equal to search key
  def search({key, value, _left, _right}, key), do: {:ok, value}

  # Search left subtree
  def search({root_key, _value, left, _right}, key) when key < root_key do
    search(left, key)
  end

  # Search right subtree
  def search({root_key, _value, _left, right}, key) when key > root_key do
    search(right, key)
  end

  @doc """
  Deletes a node from the tree
  """
  # Delete from empty tree
  def delete(nil, _key), do: nil

  # Delete root node with no children
  def delete({key, _value, nil, nil}, key), do: nil

  # Delete root node with left child
  def delete({key, _value, left, nil}, key), do: left

  # Delete root node with right child
  def delete({key, _value, nil, right}, key), do: right

  # Delete root node with two children. This is done by copying the in-order
  # predecessor to the root and then recursivley deleting the predecessor in the 
  # left subtree
  def delete({key, _value, left, right}, key) do
    {pre_key, pre_value, _left, _right} = max(left)
    {pre_key, pre_value, delete(left, pre_key), right}
  end

  # Delete in left subtree
  def delete({root_key, value, left, right}, key) when key < root_key do
    {root_key, value, delete(left, key), right}
  end

  # Delete in right subtree
  def delete({root_key, value, left, right}, key) when key > root_key do
    {root_key, value, left, delete(right, key)}
  end

  @doc """
  Returns the maximum height of the tree. An empty tree has height 0
  """
  def height(nil), do: 0
  def height({_k, _v, left, right}) do
    1 + Enum.max([height(left), height(right)])
  end

  # Returns the maximum (right-most) subtree of a tree
  defp max({_k, _v, _left, nil} = tree), do: tree
  defp max({_k, _v, _left, right}), do: max(right)
end
