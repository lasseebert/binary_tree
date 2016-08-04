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
  end

  describe "search" do
    test "it finds existing item" do
      tree = BinaryTree.new
              |> BinaryTree.insert(5, "five")
              |> BinaryTree.insert(6, "six")
              |> BinaryTree.insert(4, "four")
              |> BinaryTree.insert(3, "three")

      assert BinaryTree.search(tree, 3) == {:ok, "three"}
    end

    test "it reports not_found when not found" do
      tree = BinaryTree.new
              |> BinaryTree.insert(5, "five")
              |> BinaryTree.insert(6, "six")
              |> BinaryTree.insert(4, "four")
              |> BinaryTree.insert(3, "three")

      assert BinaryTree.search(tree, 7) == {:error, :not_found}
    end
  end
end
