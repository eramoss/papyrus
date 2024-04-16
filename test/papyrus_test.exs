defmodule PapyrusTest do
  use ExUnit.Case
  doctest Papyrus
  doctest Papyrus.Algorithms

  defmodule MatrixTest do
    use ExUnit.Case
    doctest Papyrus.Matrix
    alias Papyrus.Matrix

    test "transpose non square matrix" do
      assert Matrix.transpose([[1, 2, 3], [4, 5, 6]]) == [[1, 4], [2, 5], [3, 6]]
    end

    test "multiply two matrices with different dimensions" do
      assert_raise ArgumentError, fn ->
        Matrix.multiply([[1, 2], [3, 4]], [[5, 6], [7, 8], [9, 10]])
      end
    end

    test "add two matrices with different dimensions" do
      assert_raise ArgumentError, fn ->
        Matrix.add([[1, 2], [3, 4]], [[5, 6], [7, 8], [9, 10]])
      end
    end

    test "echelon form with pivot = 0" do
      assert Matrix.echelon_form([[0,4,5], [1,2,3], [6,7,8]]) == [[1,2,3], [0,4,5], [0,0,-3.75]]
    end

    test "echelon form tracking swap" do
      assert Matrix.echelon_form([[0,4,5], [1,2,3], [6,7,8]], true) == {[[1,2,3], [0,4,5], [0,0,-3.75]], 1} # 1 swap was made
    end

    test "det of one element matrix" do
      assert Matrix.det_by_echelon([[1.0]]) == 1.0
    end
  end

  defmodule VectorTest do
    alias Papyrus.Vector
    use ExUnit.Case
    doctest Papyrus.Vector
    test "multiply row col with different len" do
      assert_raise ArgumentError, fn ->
        Vector.dot_product([1, 2], [3, 4, 5])
      end
    end
  end
end
