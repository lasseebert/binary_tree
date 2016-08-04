defmodule BinaryTreeTest do
  use ExUnit.Case
  doctest BinaryTree

  describe "insert" do
    test "insert an element to an empty tree" do
      tree = BinaryTree.new
              |> BinaryTree.insert(1)

      assert 1 == BinaryTree.height(tree)
      assert {:ok, 1} == BinaryTree.search(tree, 1)
    end

    test "insert two elements in increasing order" do
      tree = BinaryTree.new
              |> BinaryTree.insert(1)
              |> BinaryTree.insert(2)

      assert 2 == BinaryTree.height(tree)
      assert {:ok, 1} == BinaryTree.search(tree, 1)
      assert {:ok, 2} == BinaryTree.search(tree, 2)
    end

    test "insert two elements in decreasing order" do
      tree = BinaryTree.new
              |> BinaryTree.insert(2)
              |> BinaryTree.insert(1)

      assert 2 == BinaryTree.height(tree)
      assert {:ok, 1} == BinaryTree.search(tree, 1)
      assert {:ok, 2} == BinaryTree.search(tree, 2)
    end

    test "insert a bunch of elements" do
      tree = BinaryTree.new
              |> BinaryTree.insert(5)
              |> BinaryTree.insert(6)
              |> BinaryTree.insert(4)
              |> BinaryTree.insert(3)

      assert 3 == BinaryTree.height(tree)
      assert {:ok, 3} == BinaryTree.search(tree, 3)
      assert {:ok, 4} == BinaryTree.search(tree, 4)
      assert {:ok, 5} == BinaryTree.search(tree, 5)
      assert {:ok, 6} == BinaryTree.search(tree, 6)
    end

    test "insert the same element overwrites it" do
      tree = BinaryTree.new
              |> BinaryTree.insert(5, "fyve")
              |> BinaryTree.insert(5, "five")

      assert 1 == BinaryTree.height(tree)
      assert {:ok, "five"} == BinaryTree.search(tree, 5)
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
