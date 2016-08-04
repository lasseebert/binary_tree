defmodule BinaryTree do
  @moduledoc """
  A binary search tree.

  This is implemeted as a self balancing AA tree
  See: https://en.wikipedia.org/wiki/AA_tree
  """

  defstruct(
    key: nil,
    value: nil,
    level: 1,
    left: nil,
    right: nil
  )

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
  Inserts a key-value pair into the tree
  """
  # Insertion into an empty tree
  def insert(nil, key, value) do
    %__MODULE__{key: key, value: value}
  end

  # Replace existing key with new value
  def insert(%__MODULE__{key: key} = node, key, value) do
    %{node | value: value}
  end

  # Insert in left subtree
  def insert(%__MODULE__{key: root_key} = node, key, value) when key < root_key do
    %{node | left: insert(node.left, key, value)}
    |> skew
    |> split
  end

  # Insert in right subtree
  def insert(%__MODULE__{key: root_key} = node, key, value) when key > root_key do
    %{node | right: insert(node.right, key, value)}
    |> skew
    |> split
  end

  @doc """
  Searches for a key in the tree, returns {:ok, value} if found and
  {:error, :not_found} otherwise
  """
  # Search in empty tree
  def search(nil, _key), do: {:error, :not_found}

  # Search in tree with root key equal to search key
  def search(%__MODULE__{key: key, value: value}, key), do: {:ok, value}

  # Search left subtree
  def search(%__MODULE__{key: root_key, left: left}, key) when key < root_key do
    search(left, key)
  end

  # Search right subtree
  def search(%__MODULE__{key: root_key, right: right}, key) when key > root_key do
    search(right, key)
  end

  @doc """
  Deletes a node from the tree
  """
  # Delete from empty tree
  def delete(nil, _key), do: nil

  # Delete root node with no children
  def delete(%__MODULE__{key: key, left: nil, right: nil}, key), do: nil

  # Delete root node with left child
  def delete(%__MODULE__{key: key, left: left, right: nil}, key), do: left

  # Delete root node with right child
  def delete(%__MODULE__{key: key, left: nil, right: right}, key), do: right

  # Delete root node with two children. This is done by copying the in-order
  # predecessor to the root and then recursivley deleting the predecessor in the 
  # left subtree
  def delete(%__MODULE__{key: key} = node, key) do
    predecessor = max(node.left)
    %{node | left: delete(node.left, predecessor.key), key: predecessor.key, value: predecessor.value}
  end

  # Delete in left subtree
  def delete(%__MODULE__{key: root_key} = node, key) when key < root_key do
    %{node | left: delete(node.left, key)}
  end

  # Delete in right subtree
  def delete(%__MODULE__{key: root_key} = node, key) when key > root_key do
    %{node | right: delete(node.right, key)}
  end

  @doc """
  Returns the maximum height of the tree. An empty tree has height 0
  Note: It traverses the entire tree. Use with caution
  """
  def height(nil), do: 0
  def height(%__MODULE__{} = node) do
    1 + Enum.max([height(node.left), height(node.right)])
  end

  # Returns the maximum (right-most) subtree of a tree
  defp max(%__MODULE__{right: nil} = node), do: node
  defp max(%__MODULE__{right: right}), do: max(right)

  # Rotate tree to turn an invalid left horizontal link into a valid right
  # horizontal link
  defp skew(nil), do: nil
  defp skew(%__MODULE__{left: nil} = node), do: node
  defp skew(%__MODULE__{level: level, left: %__MODULE__{level: level}} = node) do
    %{node.left | right: %{node | left: node.left.right}}
  end
  defp skew(%__MODULE__{} = node), do: node

  # Rotate tree to turn a double right horizontal link into a tree with a higher
  # level
  defp split(nil), do: nil
  defp split(%__MODULE__{right: nil} = node), do: node
  defp split(%__MODULE__{right: %__MODULE__{right: nil}} = node), do: node
  defp split(%__MODULE__{level: level, right: %__MODULE__{right: %__MODULE__{level: level}}} = node) do
    %{node.right | level: node.right.level + 1, left: %{node | right: node.right.left}}
  end
  defp split(%__MODULE__{} = node), do: node
end
