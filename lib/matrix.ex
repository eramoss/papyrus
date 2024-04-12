defmodule Matrix do
  @moduledoc """
  A module for performing operations on matrices.
  """

  @doc """
  Adds two matrices together.

  ## Examples

      iex> Matrix.add([[1, 2], [3, 4]], [[5, 6], [7, 8]])
      [[6, 8], [10, 12]]
  """
  def add(matrix_a, matrix_b) do
    if length(matrix_a) != length(matrix_b) do
      raise ArgumentError, "Matrices must have the same dimensions"
    else
      Enum.zip(matrix_a, matrix_b) |> Enum.map(fn {a, b} -> add_row(a, b) end)
    end
  end

  @doc """
  Adds two rows of a matrix together.

  ## Examples

      iex> Matrix.add_row([1, 2], [3, 4])
      [4, 6]
  """
  def add_row(row_a, row_b) do
    Enum.zip(row_a, row_b) |> Enum.map(fn {a, b} -> a + b end)
  end

  @doc """
  Multiplies a matrix by a scalar.

  ## Examples

      iex> Matrix.multiply_linear([[1, 2], [3, 4]], 2)
      [[2, 4], [6, 8]]
  """
  def multiply_linear(matrix, a) do
    Enum.map(matrix, fn row -> multiply_row(row, a) end)
  end

  @doc """
  Multiplies two matrices together.

  ## Examples

      iex> Matrix.multiply([[1, 2], [3, 4]], [[5, 6], [7, 8]])
      [[19, 22], [43, 50]]
  """
  def multiply(matrix_a, matrix_b) do
    Enum.map(matrix_a, fn row_a ->
      Enum.map(transpose(matrix_b), fn col_b ->
        multiply_row_col(row_a, col_b)
      end)
    end)
  end

  @doc """
  Multiplies a row and a column of a matrix.

  ## Examples

      iex> Matrix.multiply_row_col([1, 2], [3, 4])
      11
  """
  def multiply_row_col(row, col) do
    if length(row) != length(col) do
      raise ArgumentError, "Row and column lengths must be the same"
    else
      Enum.zip(row, col) |> Enum.reduce(0, fn {a, b}, acc -> a * b + acc end)
    end
  end

  @doc """
  Multiplies a row of a matrix by a scalar.

  ## Examples

      iex> Matrix.multiply_row([1, 2], 2)
      [2, 4]
  """
  def multiply_row(row, a) do
    Enum.map(row, fn x -> x * a end)
  end

  @doc """
  Transposes a matrix.

  ## Examples

      iex> Matrix.transpose([[1, 2], [3, 4]])
      [[1, 3], [2, 4]]
  """
  def transpose(matrix) do
    Enum.map(0..(length(hd(matrix)) - 1), fn i -> Enum.map(matrix, fn row -> Enum.at(row, i) end) end)
  end

  @doc """
  swap rows of a matrix

  ## Examples

      iex> Matrix.swap_rows([[1, 2], [3, 4]], 0, 1)
      [[3, 4], [1, 2]]
  """
  def swap_rows(matrix, i, j) do
    Enum.with_index(matrix) |> Enum.map(fn {row, idx} ->
      if idx == i do
        Enum.at(matrix, j)
      else if idx == j do
        Enum.at(matrix, i)
      else
        row
        end
      end
    end)
  end


  @doc """
  Convert a matrix to echelon form

  ## Examples

      iex> Matrix.echelon_form([[1,2],[3,4]])
      [[1, 2], [0.0, -2.0]]
  """
  def echelon_form(matrix) do
    echelon_form(matrix, false) # tracker swaps to false
  end

  def echelon_form(matrix, false) do
    Enum.reduce(0..(length(matrix) - 2), matrix, fn i, acc ->
      Enum.reduce(i..(length(matrix) - 2), acc, fn j, acc2 ->
          pivot = Enum.at(Enum.at(acc2, i), i)
          if pivot == 0 do
            swap_rows(acc2, i, i + 1)
          else
            multiplier = Papyrus.Utils.inverse_multiplier(pivot, Enum.at(Enum.at(acc2, j + 1), i))
            replace_row(acc2, j + 1, add_row(Enum.at(acc2, j + 1), multiply_row(Enum.at(acc2, i), multiplier)))
          end
        end)
      end)
  end

  def echelon_form(matrix, true) do
    Enum.reduce(0..(length(matrix) - 2), {matrix, 0}, fn i, {acc, swaps} ->
      Enum.reduce(i..(length(matrix) - 2), {acc, swaps}, fn j, {acc2, swaps2} ->
        pivot = Enum.at(Enum.at(acc2, i), i)
        if pivot == 0 do
          {swap_rows(acc2, i, i + 1), swaps2 + 1}
        else
          multiplier = Papyrus.Utils.inverse_multiplier(pivot, Enum.at(Enum.at(acc2, j + 1), i))
          {replace_row(acc2, j + 1, add_row(Enum.at(acc2, j + 1), multiply_row(Enum.at(acc2, i), multiplier))), swaps2}
        end
      end)
    end)
  end



  def det_by_echelon([[el]]) do
    el
  end
  @doc """
  Calculate the determinant of a matrix using echelon form

  ## Examples

      iex> Matrix.det_by_echelon([[0,4,5], [1,2,3], [6,7,8]])
      15.0
  """
  def det_by_echelon(matrix) do
    {echelon, swaps} = echelon_form(matrix, true)
    det = Enum.reduce(0..(length(echelon) - 1), 1, fn i, acc -> acc * Enum.at(Enum.at(echelon, i), i) end)
    det * :math.pow(-1, swaps)
  end


  @doc """
  Replace a row in a matrix

  ## Examples

      iex> Matrix.replace_row([[1,2],[3,4]], 0, [5,6])
      [[5, 6], [3, 4]]

  """
  def replace_row(matrix, i, row) do
    Enum.with_index(matrix) |> Enum.map(fn {r, idx} -> if idx == i do row else r end end)
  end


  @doc """
  Calculate the inverse of a matrix

  ## Examples

      iex> Matrix.inverse([[1,2],[3,4]])
      [[-2.0, 1.0], [1.5, -0.5]]
  """
  def inverse(matrix) do
    adjoint(matrix) |> multiply_linear(1 / det_by_echelon(matrix))
  end


  @doc """
  Calculate the adjoint of a matrix

  ## Examples

      iex> Matrix.adjoint([[1,2],[3,4]])
      [[4.0, -2.0], [-3.0, 1.0]]
  """
  def adjoint(matrix) do
    transpose(comatrix(matrix))
  end

  @doc """
  Calculate the matrix of cofactors of a matrix

  ## Examples

      iex> Matrix.comatrix([[1,2],[3,4]])
      [[4.0, -3.0], [-2.0, 1.0]]
  """
  def comatrix(matrix) do
    Enum.with_index(matrix) |> Enum.map(fn {row, i} -> Enum.with_index(row) |> Enum.map(fn {_, j} -> cofactor(matrix, i, j) end) end)
  end

  @doc """
  Calculate the cofactor of an element in a matrix

  ## Examples

      iex> Matrix.cofactor([[1,2],[3,4]], 0, 0)
      4.0
  """
  def cofactor(matrix, i, j) do
    minor(matrix, i, j) * :math.pow(-1, i + j)
  end


  @doc """
  Calculate the minor of an element in a matrix

  ## Examples

      iex> Matrix.minor([[1,2],[3,4]], 0, 0)
      4
  """
  def minor(matrix, i, j) do
    det_by_echelon(minor_matrix(matrix, i, j))
  end


  @doc """
  Calculate the minor matrix of an element

  ## Examples

      iex> Matrix.minor_matrix([[1,2],[3,4]], 0, 0)
      [[4]]
  """
  def minor_matrix(matrix, i, j) do
   result = Enum.with_index(matrix, fn row , index ->
      Enum.with_index(row, fn el, index2 ->
        if !(index == i || index2 == j) do
          el
        end
      end)
    end)
    result = Enum.map(result, fn row -> Enum.filter(row, fn x -> x != nil end) end)
    Enum.filter(result, fn x -> x != [] end)
  end

end
