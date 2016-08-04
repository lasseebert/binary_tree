defmodule BinaryTreeTest do
  use ExUnit.Case
  doctest BinaryTree

  describe "insert" do
    test "insert an element to an empty tree" do
      result = BinaryTree.new
                |> BinaryTree.insert(1)

      assert result == {1, 1, nil, nil}
    end

    test "insert two elements in increasing order" do
      result = BinaryTree.new
                |> BinaryTree.insert(1)
                |> BinaryTree.insert(2)

      assert result == {1, 1, nil, {2, 2, nil, nil}}
    end

    test "insert two elements in decreasing order" do
      result = BinaryTree.new
                |> BinaryTree.insert(2)
                |> BinaryTree.insert(1)

      assert result == {2, 2, {1, 1, nil, nil}, nil}
    end

    test "insert a bunch of elements" do
      result = BinaryTree.new
                |> BinaryTree.insert(5)
                |> BinaryTree.insert(6)
                |> BinaryTree.insert(4)
                |> BinaryTree.insert(3)

      assert result == {
        5, 5,
        {
          4, 4,
          {3, 3, nil, nil},
          nil
        },
        {
          6, 6, nil, nil
        }
      }
    end

    test "it is balanced" do
      tree = 1..1000
              |> Enum.reduce(BinaryTree.new, fn value, tree -> BinaryTree.insert(tree, value) end)

      assert BinaryTree.height(tree) < 100
    end
  end

  describe "search" do
    setup [:build_tree]

    test "it finds existing item", %{tree: tree} do
      assert BinaryTree.search(tree, 3) == {:ok, "three"}
    end

    test "it reports not_found when not found", %{tree: tree} do
      assert BinaryTree.search(tree, 7) == {:error, :not_found}
    end
  end

  describe "delete" do
    setup [:build_tree]

    test "it deletes a leaf", %{tree: tree} do
      tree = BinaryTree.delete(tree, 2)

      assert {:error, :not_found} == BinaryTree.search(tree, 2)
      assert {:ok, "three"} == BinaryTree.search(tree, 3)
    end

    test "it deletes root when only root exists" do
      tree = BinaryTree.new
              |> BinaryTree.insert(2)
              |> BinaryTree.delete(2)
      assert tree == BinaryTree.new
    end

    test "it deletes node with one child", %{tree: tree} do
      tree = BinaryTree.delete(tree, 6)

      assert {:error, :not_found} == BinaryTree.search(tree, 6)
      assert {:ok, "five"} == BinaryTree.search(tree, 5)
      assert {:ok, "eight"} == BinaryTree.search(tree, 8)
    end

    test "it deletes node with two children", %{tree: tree} do
      tree = BinaryTree.delete(tree, 3)

      assert {:error, :not_found} == BinaryTree.search(tree, 3)
      assert {:ok, "two"} == BinaryTree.search(tree, 2)
      assert {:ok, "four"} == BinaryTree.search(tree, 4)
      assert {:ok, "five"} == BinaryTree.search(tree, 5)
      assert {:ok, "eight"} == BinaryTree.search(tree, 8)
    end

    test "it returns the same tree if key does not exist", %{tree: tree} do
      new_tree = BinaryTree.delete(tree, 7)

      assert new_tree == tree
    end
  end

  defp build_tree(_context) do
      tree = BinaryTree.new
              |> BinaryTree.insert(5, "five")
              |> BinaryTree.insert(6, "six")
              |> BinaryTree.insert(3, "three")
              |> BinaryTree.insert(4, "four")
              |> BinaryTree.insert(2, "two")
              |> BinaryTree.insert(8, "eight")
    %{tree: tree}
  end
end
